Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCC67CE847
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 21:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjJRT4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 15:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjJRT4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 15:56:44 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139D395
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 12:56:42 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9a3942461aso10560070276.2
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 12:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697659001; x=1698263801; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Px1WBvBiMUlKzpscWsJjyfSW5bylu5iQGwjDIacRRw=;
        b=WSCUtZHs1URuDak4Mfsny32PPZfosW01uye3kaefIhQUbTd+VrHG2NkUX5UIAKTF3t
         55NEmv2MlS2G81Sg4fD0qLUd+X6N6P5ff9USxREQ2SttNvyerIOrz30VOCGl9zseakdm
         ZmLb38a4ZCWH13hbgYTugnL3kIVehlT0Dow1qeeYhnBC5splTgC8FJ6mfldK7ba7D8Bt
         UJ/q+jqWlJgDF4so5Zy4O355nUJAjqOqNvcbrbi5El+Akx5C2IoHBB6+VY99TBlIvl4U
         N9ufIZt5d3ncVzZSdx2SS5dwAXqH7aLbrEFhiuECNLc5arCSSivCGu3/iHN5V0QRce0C
         yjNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697659001; x=1698263801;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Px1WBvBiMUlKzpscWsJjyfSW5bylu5iQGwjDIacRRw=;
        b=lCP2teEUdog1eMVGyNtEYPChAZ54mmr5Y0y5sRJcgSrLj25ewDygIdOT+YcMJP/xed
         NwSpCv4MGZeojE2mA5IWQKqQCO57FmmW6cPXzuD6m1Sds2FPLNtd1FSC37eNUldS5bvK
         gOY4wfte5jJy/SP4DfSeL/3daCKJ3gy3U/wDKQIhFveHaKE2AdI+C7xXwObzwN4k2I7j
         EOA4f6Goew4La1uiQSbvQ6a82awhJ+u3JLqp/1XTUdRhjvt4VuhVlCUd58xaGjta7tyf
         FFYvhUSllybP7UF0g6GnRLOyCeQepRnIjU4QAWQmKFlWWbYiGQGUKopgZpBExORTs7iC
         VQmg==
X-Gm-Message-State: AOJu0YyNMZ3XFuRuuUI/VzWTYNSpkobSMXz8ZRHlX5B/xbPLw+8/s8sU
        +nqme+rov9v9E/3HpLDPjXFyZJMoYmg=
X-Google-Smtp-Source: AGHT+IEe5pC9E9+764ikf53DzXH5fgQkzfx9O7EUdVpYf58+rq+qSU1Fg3oabspoJky6n9lKhdYX8vEfM6M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:fd6:0:b0:d9a:3d02:b55 with SMTP id
 205-20020a250fd6000000b00d9a3d020b55mr10226ybp.0.1697659001238; Wed, 18 Oct
 2023 12:56:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 18 Oct 2023 12:56:38 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231018195638.1898375-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Don't unnecessarily force masterclock update on
 vCPU hotplug
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dongli Zhang <dongli.zhang@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't force a masterclock update when a vCPU synchronizes to the current
TSC generation, e.g. when userspace hotplugs a pre-created vCPU into the
VM.  Unnecessarily updating the masterclock is undesirable as it can cause
kvmclock's time to jump, which is particularly painful on systems with a
stable TSC as kvmclock _should_ be fully reliable on such systems.

The unexpected time jumps are due to differences in the TSC=>nanoseconds
conversion algorithms between kvmclock and the host's CLOCK_MONOTONIC_RAW
(the pvclock algorithm is inherently lossy).  When updating the
masterclock, KVM refreshes the "base", i.e. moves the elapsed time since
the last update from the kvmclock/pvclock algorithm to the
CLOCK_MONOTONIC_RAW algorithm.  Synchronizing kvmclock with
CLOCK_MONOTONIC_RAW is the lesser of evils when the TSC is unstable, but
adds no real value when the TSC is stable.

Prior to commit 7f187922ddf6 ("KVM: x86: update masterclock values on TSC
writes"), KVM did NOT force an update when synchronizing a vCPU to the
current generation.

  commit 7f187922ddf6b67f2999a76dcb71663097b75497
  Author: Marcelo Tosatti <mtosatti@redhat.com>
  Date:   Tue Nov 4 21:30:44 2014 -0200

    KVM: x86: update masterclock values on TSC writes

    When the guest writes to the TSC, the masterclock TSC copy must be
    updated as well along with the TSC_OFFSET update, otherwise a negative
    tsc_timestamp is calculated at kvm_guest_time_update.

    Once "if (!vcpus_matched && ka->use_master_clock)" is simplified to
    "if (ka->use_master_clock)", the corresponding "if (!ka->use_master_clock)"
    becomes redundant, so remove the do_request boolean and collapse
    everything into a single condition.

Before that, KVM only re-synced the masterclock if the masterclock was
enabled or disabled  Note, at the time of the above commit, VMX
synchronized TSC on *guest* writes to MSR_IA32_TSC:

        case MSR_IA32_TSC:
                kvm_write_tsc(vcpu, msr_info);
                break;

which is why the changelog specifically says "guest writes", but the bug
that was being fixed wasn't unique to guest write, i.e. a TSC write from
the host would suffer the same problem.

So even though KVM stopped synchronizing on guest writes as of commit
0c899c25d754 ("KVM: x86: do not attempt TSC synchronization on guest
writes"), simply reverting commit 7f187922ddf6 is not an option.  Figuring
out how a negative tsc_timestamp could be computed requires a bit more
sleuthing.

In kvm_write_tsc() (at the time), except for KVM's "less than 1 second"
hack, KVM snapshotted the vCPU's current TSC *and* the current time in
nanoseconds, where kvm->arch.cur_tsc_nsec is the current host kernel time
in nanoseconds:

        ns = get_kernel_ns();

        ...

        if (usdiff < USEC_PER_SEC &&
            vcpu->arch.virtual_tsc_khz == kvm->arch.last_tsc_khz) {
                ...
        } else {
                /*
                 * We split periods of matched TSC writes into generations.
                 * For each generation, we track the original measured
                 * nanosecond time, offset, and write, so if TSCs are in
                 * sync, we can match exact offset, and if not, we can match
                 * exact software computation in compute_guest_tsc()
                 *
                 * These values are tracked in kvm->arch.cur_xxx variables.
                 */
                kvm->arch.cur_tsc_generation++;
                kvm->arch.cur_tsc_nsec = ns;
                kvm->arch.cur_tsc_write = data;
                kvm->arch.cur_tsc_offset = offset;
                matched = false;
                pr_debug("kvm: new tsc generation %llu, clock %llu\n",
                         kvm->arch.cur_tsc_generation, data);
        }

        ...

        /* Keep track of which generation this VCPU has synchronized to */
        vcpu->arch.this_tsc_generation = kvm->arch.cur_tsc_generation;
        vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
        vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;

Note that the above creates a new generation and sets "matched" to false!
But because kvm_track_tsc_matching() looks for matched+1, i.e. doesn't
require the vCPU that creates the new generation to match itself, KVM
would immediately compute vcpus_matched as true for VMs with a single vCPU.
As a result, KVM would skip the masterlock update, even though a new TSC
generation was created:

        vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
                         atomic_read(&vcpu->kvm->online_vcpus));

        if (vcpus_matched && gtod->clock.vclock_mode == VCLOCK_TSC)
                if (!ka->use_master_clock)
                        do_request = 1;

        if (!vcpus_matched && ka->use_master_clock)
                        do_request = 1;

        if (do_request)
                kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);

On hardware without TSC scaling support, vcpu->tsc_catchup is set to true
if the guest TSC frequency is faster than the host TSC frequency, even if
the TSC is otherwise stable.  And for that mode, kvm_guest_time_update(),
by way of compute_guest_tsc(), uses vcpu->arch.this_tsc_nsec, a.k.a. the
kernel time at the last TSC write, to compute the guest TSC relative to
kernel time:

  static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
  {
        u64 tsc = pvclock_scale_delta(kernel_ns-vcpu->arch.this_tsc_nsec,
                                      vcpu->arch.virtual_tsc_mult,
                                      vcpu->arch.virtual_tsc_shift);
        tsc += vcpu->arch.this_tsc_write;
        return tsc;
  }

Except the "kernel_ns" passed to compute_guest_tsc() isn't the current
kernel time, it's the masterclock snapshot!

        spin_lock(&ka->pvclock_gtod_sync_lock);
        use_master_clock = ka->use_master_clock;
        if (use_master_clock) {
                host_tsc = ka->master_cycle_now;
                kernel_ns = ka->master_kernel_ns;
        }
        spin_unlock(&ka->pvclock_gtod_sync_lock);

        if (vcpu->tsc_catchup) {
                u64 tsc = compute_guest_tsc(v, kernel_ns);
                if (tsc > tsc_timestamp) {
                        adjust_tsc_offset_guest(v, tsc - tsc_timestamp);
                        tsc_timestamp = tsc;
                }
        }

And so when KVM skips the masterclock update after a TSC write, i.e. after
a new TSC generation is started, the "kernel_ns-vcpu->arch.this_tsc_nsec"
is *guaranteed* to generate a negative value, because this_tsc_nsec was
captured after ka->master_kernel_ns.

Forcing a masterclock update essentially fudged around that problem, but
in a heavy handed way that introduced undesirable side effects, i.e.
unnecessarily forces a masterclock update when a new vCPU joins the party
via hotplug.

Note, KVM forces masterclock updates in other weird ways that are also
likely unnecessary, e.g. when establishing a new Xen shared info page and
when userspace creates a brand new vCPU.  But the Xen thing is firmly a
separate mess, and there are no known userspace VMMs that utilize kvmclock
*and* create new vCPUs after the VM is up and running.  I.e. the other
issues are future problems.

Reported-by: Dongli Zhang <dongli.zhang@oracle.com>
Closes: https://lore.kernel.org/all/20230926230649.67852-1-dongli.zhang@oracle.com
Fixes: 7f187922ddf6 ("KVM: x86: update masterclock values on TSC writes")
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 530d4bc2259b..61bdb6c1d000 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2510,26 +2510,29 @@ static inline int gtod_is_based_on_tsc(int mode)
 }
 #endif
 
-static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
+static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu, bool new_generation)
 {
 #ifdef CONFIG_X86_64
-	bool vcpus_matched;
 	struct kvm_arch *ka = &vcpu->kvm->arch;
 	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
 
-	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
-			 atomic_read(&vcpu->kvm->online_vcpus));
+	/*
+	 * To use the masterclock, the host clocksource must be based on TSC
+	 * and all vCPUs must have matching TSCs.  Note, the count for matching
+	 * vCPUs doesn't include the reference vCPU, hence "+1".
+	 */
+	bool use_master_clock = (ka->nr_vcpus_matched_tsc + 1 ==
+				 atomic_read(&vcpu->kvm->online_vcpus)) &&
+				gtod_is_based_on_tsc(gtod->clock.vclock_mode);
 
 	/*
-	 * Once the masterclock is enabled, always perform request in
-	 * order to update it.
-	 *
-	 * In order to enable masterclock, the host clocksource must be TSC
-	 * and the vcpus need to have matched TSCs.  When that happens,
-	 * perform request to enable masterclock.
+	 * Request a masterclock update if the masterclock needs to be toggled
+	 * on/off, or when starting a new generation and the masterclock is
+	 * enabled (compute_guest_tsc() requires the masterclock snapshot to be
+	 * taken _after_ the new generation is created).
 	 */
-	if (ka->use_master_clock ||
-	    (gtod_is_based_on_tsc(gtod->clock.vclock_mode) && vcpus_matched))
+	if ((ka->use_master_clock && new_generation) ||
+	    (ka->use_master_clock != use_master_clock))
 		kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
 
 	trace_kvm_track_tsc(vcpu->vcpu_id, ka->nr_vcpus_matched_tsc,
@@ -2706,7 +2709,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
 	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
 
-	kvm_track_tsc_matching(vcpu);
+	kvm_track_tsc_matching(vcpu, !matched);
 }
 
 static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)

base-commit: 437bba5ad2bba00c2056c896753a32edf80860cc
-- 
2.42.0.655.g421f12c284-goog

