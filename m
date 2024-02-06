Return-Path: <kvm+bounces-8104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D039D84B95D
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 16:25:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F2A31F26F1F
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 15:25:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B39D134739;
	Tue,  6 Feb 2024 15:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vkb9JBRZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1753133982
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 15:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232798; cv=none; b=dK9KnmFi4t8gUGiQgE44bZVVlsq6G/Wgrb4Uw+kQ+UlVLTAEkjf9Ozlt9EIzN0qOyTJRuf+0697L+nct4jSMPyRfRXQ4KIUV0RPQ300ERCLtx8MlksKlhs5ckAdDsis1dTK0jMJZUzECq/6/fNLwsuhYP5PEZUG534+K+ILp1oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232798; c=relaxed/simple;
	bh=oyBbD9O77fdzA3mKoUnOeLqCcbuiPoR6Vq4YQ19WT8g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kDioWxLSigASz+HNX5L6G/yAyhufMfkwG6E9eilr/H50pW/NGU9tHK/A0JhbG6RbWl2PR1vANwTR/wxA+REtN9Gl5O3iWHWWALRK5CtyVD3xjP0ldG/j/nCrnryGlrvddthSFjKMAc9yuR9NKk/JHca185n52ciMaz3fytgiCzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vkb9JBRZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707232795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=J8tSMCLStu5rYwI8aLzXD9+zfv3RFVQ4/1ORcx+dqxU=;
	b=Vkb9JBRZ/N1gmhvsHJSZLpNqSVuKV547CXnuxaqIPnwHTp1ZAT9suzignHQXKgXpruvwXj
	ZkBUG2BgBvSkH5/1oN4nF66GwZ2PgcVl8HMJ74yMl2C530W1vovG5jXxzZqAjM9jn6WbFD
	yYFbnjC03tBrWDvxGr9FszxbKT4IL54=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-4CMy8lo5Nk2OaA6PlWeI_g-1; Tue,
 06 Feb 2024 10:19:52 -0500
X-MC-Unique: 4CMy8lo5Nk2OaA6PlWeI_g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CE1A3813BD2;
	Tue,  6 Feb 2024 15:19:52 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.57])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1EBCB1C060AF;
	Tue,  6 Feb 2024 15:19:51 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	David Woodhouse <dwmw@amazon.co.uk>
Cc: Jan Richter <jarichte@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: selftests: Compare wall time from xen shinfo against KVM_GET_CLOCK
Date: Tue,  6 Feb 2024 16:19:50 +0100
Message-ID: <20240206151950.31174-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

xen_shinfo_test is observed to be flaky failing sporadically with
"VM time too old". With min_ts/max_ts debug print added:

Wall clock (v 3269818) 1704906491.986255664
Time info 1: v 1282712 tsc 33530585736 time 14014430025 mul 3587552223 shift 4294967295 flags 1
Time info 2: v 1282712 tsc 33530585736 time 14014430025 mul 3587552223 shift 4294967295 flags 1
min_ts: 1704906491.986312153
max_ts: 1704906506.001006963
==== Test Assertion Failure ====
  x86_64/xen_shinfo_test.c:1003: cmp_timespec(&min_ts, &vm_ts) <= 0
  pid=32724 tid=32724 errno=4 - Interrupted system call
     1	0x00000000004030ad: main at xen_shinfo_test.c:1003
     2	0x00007fca6b23feaf: ?? ??:0
     3	0x00007fca6b23ff5f: ?? ??:0
     4	0x0000000000405e04: _start at ??:?
  VM time too old

The test compares wall clock data from shinfo (which is the output of
kvm_get_wall_clock_epoch()) against clock_gettime(CLOCK_REALTIME) in the
host system before the VM is created. In the example above, it compares

 shinfo: 1704906491.986255664 vs min_ts: 1704906491.986312153

and fails as the later is greater than the former.  While this sounds like
a sane test, it doesn't pass reality check: kvm_get_wall_clock_epoch()
calculates guest's epoch (realtime when the guest was created) by
subtracting kvmclock from the current realtime and the calculation happens
when shinfo is setup. The problem is that kvmclock is a raw clock and
realtime clock is affected by NTP. This means that if realtime ticks with a
slightly reduced frequency, "guest's epoch" calculated by
kvm_get_wall_clock_epoch() will actually tick backwards! This is not a big
issue from guest's perspective as the guest can't really observe this but
this epoch can't be compared with a fixed clock_gettime() on the host.

Replace the check with comparing wall clock data from shinfo to
KVM_GET_CLOCK. The later gives both realtime and kvmclock so guest's epoch
can be calculated by subtraction. Note, CLOCK_REALTIME is susceptible to
leap seconds jumps but there's no better alternative in KVM at this
moment. Leave a comment and accept 1s delta.

Reported-by: Jan Richter <jarichte@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
Changes since v1 [David Woodhouse]:
- Check for KVM_CLOCK_REALTIME and skip testing shinfo epoch sanity in case
it's missing (e.g. when a non-TSC clocksource is used)
- Add a comment about a potential jump of CLOCK_REALTIME because of a leap
second injection and accept 1s delta. While this is very unlikely anyone
will even hit this in testing, this mostly serves a documentation purpose.
---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 50 +++++++++++--------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 9ec9ab60b63e..e6e3553633b1 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -375,20 +375,6 @@ static void guest_code(void)
 	GUEST_SYNC(TEST_DONE);
 }
 
-static int cmp_timespec(struct timespec *a, struct timespec *b)
-{
-	if (a->tv_sec > b->tv_sec)
-		return 1;
-	else if (a->tv_sec < b->tv_sec)
-		return -1;
-	else if (a->tv_nsec > b->tv_nsec)
-		return 1;
-	else if (a->tv_nsec < b->tv_nsec)
-		return -1;
-	else
-		return 0;
-}
-
 static struct vcpu_info *vinfo;
 static struct kvm_vcpu *vcpu;
 
@@ -425,7 +411,6 @@ static void *juggle_shinfo_state(void *arg)
 
 int main(int argc, char *argv[])
 {
-	struct timespec min_ts, max_ts, vm_ts;
 	struct kvm_xen_hvm_attr evt_reset;
 	struct kvm_vm *vm;
 	pthread_t thread;
@@ -443,8 +428,6 @@ int main(int argc, char *argv[])
 	bool do_eventfd_tests = !!(xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL);
 	bool do_evtchn_tests = do_eventfd_tests && !!(xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_SEND);
 
-	clock_gettime(CLOCK_REALTIME, &min_ts);
-
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	/* Map a region for the shared_info page */
@@ -969,7 +952,6 @@ int main(int argc, char *argv[])
 	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &evt_reset);
 
 	alarm(0);
-	clock_gettime(CLOCK_REALTIME, &max_ts);
 
 	/*
 	 * Just a *really* basic check that things are being put in the
@@ -978,6 +960,8 @@ int main(int argc, char *argv[])
 	 */
 	struct pvclock_wall_clock *wc;
 	struct pvclock_vcpu_time_info *ti, *ti2;
+	struct kvm_clock_data kcdata;
+	long long delta;
 
 	wc = addr_gpa2hva(vm, SHINFO_REGION_GPA + 0xc00);
 	ti = addr_gpa2hva(vm, SHINFO_REGION_GPA + 0x40 + 0x20);
@@ -993,12 +977,34 @@ int main(int argc, char *argv[])
 		       ti2->tsc_shift, ti2->flags);
 	}
 
-	vm_ts.tv_sec = wc->sec;
-	vm_ts.tv_nsec = wc->nsec;
 	TEST_ASSERT(wc->version && !(wc->version & 1),
 		    "Bad wallclock version %x", wc->version);
-	TEST_ASSERT(cmp_timespec(&min_ts, &vm_ts) <= 0, "VM time too old");
-	TEST_ASSERT(cmp_timespec(&max_ts, &vm_ts) >= 0, "VM time too new");
+
+	vm_ioctl(vm, KVM_GET_CLOCK, &kcdata);
+
+	if (kcdata.flags & KVM_CLOCK_REALTIME) {
+		if (verbose) {
+			printf("KVM_GET_CLOCK clock: %lld.%09lld\n",
+			       kcdata.clock / NSEC_PER_SEC, kcdata.clock % NSEC_PER_SEC);
+			printf("KVM_GET_CLOCK realtime: %lld.%09lld\n",
+			       kcdata.realtime / NSEC_PER_SEC, kcdata.realtime % NSEC_PER_SEC);
+		}
+
+		delta = (wc->sec * NSEC_PER_SEC + wc->nsec) - (kcdata.realtime - kcdata.clock);
+
+		/*
+		 * KVM_GET_CLOCK gives CLOCK_REALTIME which jumps on leap seconds updates but
+		 * unfortunately KVM doesn't currently offer a CLOCK_TAI alternative. Accept 1s
+		 * delta as testing clock accuracy is not the goal here. The test just needs to
+		 * check that the value in shinfo is somewhat sane.
+		 */
+		TEST_ASSERT(llabs(delta) < NSEC_PER_SEC,
+			    "Guest's epoch from shinfo %d.%09d differs from KVM_GET_CLOCK %lld.%lld",
+			    wc->sec, wc->nsec, (kcdata.realtime - kcdata.clock) / NSEC_PER_SEC,
+			    (kcdata.realtime - kcdata.clock) % NSEC_PER_SEC);
+	} else {
+		pr_info("Missing KVM_CLOCK_REALTIME, skipping shinfo epoch sanity check\n");
+	}
 
 	TEST_ASSERT(ti->version && !(ti->version & 1),
 		    "Bad time_info version %x", ti->version);
-- 
2.43.0


