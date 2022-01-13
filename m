Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAC448E04A
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 23:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237665AbiAMWdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 17:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237597AbiAMWdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 17:33:43 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465A1C06161C
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 14:33:43 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id a1-20020a17090a688100b001b3fd52338eso11325657pjd.1
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 14:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vKcApk+v768qeTjpWpmboSdBFfxqsuPGjK5dRgsX4jM=;
        b=bAJoeB2RiYvBngQJtSjk4DzjwcszoV/cVrdsM9sfV3MSt/pT7kRKNy54p6xFf+EmAL
         v9IAwutiNSEA7yptUFSgz9Ft5YqJpIMOiS99dKEdtSbluSLYAdbUQx9NDM8VcxfeMG8I
         sspnaENyS7NNTgGD9souqMvQY9fJZnUQ9EO1qTfXcHAiiSeb5SdshzcsNt+2BNSKORcg
         mQb+Wgj76dYUoIA8d4WeLNOSBiXXuFTvXV6dgJ9BQmUXRV8O+Sqiv0qZjEbiRcPoU9EX
         Nge+pGcl3H9/P3rZX4yCtRfmyHC8jLSTCJRaODgMe5IYVmtfCSsAb74m4X4LHmRilsLm
         gGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vKcApk+v768qeTjpWpmboSdBFfxqsuPGjK5dRgsX4jM=;
        b=bvDAVbVdvD71/diWZxp9VgniV7DRDXMhN96Tx57+i0S4kFKcj41SVcNiLQ2NaefCz6
         DZFHHijLz5F3wdOl3omPyducQ0cLuo6ktXrAZb6K0dI0Tv0k0xCzn7btDzzPo1+jGay1
         5wsMNgMWViFSB0Q+EiSolSMXc5P/8+OTWVW8V/QJf6iRKzfq0ox+EiKHQpQ/xX0pXJ13
         MSEgHrKO4t/jFsP8syssiL8p3GYP2M9iDZoU7ybepVyj9Ud7LFamWdg1HnlVDl/ThHQx
         9DNrJMLRhR3+PCLEHOafURBnztqDp5F7fZlemwct/+C7+cp5nsYMiBgFDEAd6waNf0PB
         Eo6g==
X-Gm-Message-State: AOAM5300sG+E8Ako/HGWiu2990Z6qgb2P0WN8KrOxm93fCx2OY4bagdU
        hIJX+xgp8J0ye3WCjgdkk/TYOLwzL4OudQ==
X-Google-Smtp-Source: ABdhPJy1dG1XyLQd/FoHARCUMiyha3iOC6KAMpd6xtooyknGcCAfn//QA8XNUoYkEyYzQYfrRvIuHA==
X-Received: by 2002:a17:902:6bc1:b0:149:7c61:ad31 with SMTP id m1-20020a1709026bc100b001497c61ad31mr6833304plt.93.1642113222479;
        Thu, 13 Jan 2022 14:33:42 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f9sm3309031pjh.18.2022.01.13.14.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 14:33:41 -0800 (PST)
Date:   Thu, 13 Jan 2022 22:33:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Message-ID: <YeCowpPBEHC6GJ59@google.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
 <20211122175818.608220-3-vkuznets@redhat.com>
 <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
 <87mtkdqm7m.fsf@redhat.com>
 <20220103104057.4dcf7948@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103104057.4dcf7948@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 03, 2022, Igor Mammedov wrote:
> On Mon, 03 Jan 2022 09:04:29 +0100
> Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> 
> > Paolo Bonzini <pbonzini@redhat.com> writes:
> > 
> > > On 12/27/21 18:32, Igor Mammedov wrote:  
> > >>> Tweaked and queued nevertheless, thanks.  
> > >> it seems this patch breaks VCPU hotplug, in scenario:
> > >> 
> > >>    1. hotunplug existing VCPU (QEMU stores VCPU file descriptor in parked cpus list)
> > >>    2. hotplug it again (unsuspecting QEMU reuses stored file descriptor when recreating VCPU)
> > >> 
> > >> RHBZ:https://bugzilla.redhat.com/show_bug.cgi?id=2028337#c11
> > >>   
> > >
> > > The fix here would be (in QEMU) to not call KVM_SET_CPUID2 again. 
> > > However, we need to work around it in KVM, and allow KVM_SET_CPUID2 if 
> > > the data passed to the ioctl is the same that was set before.  
> > 
> > Are we sure the data is going to be *exactly* the same? In particular,
> > when using vCPU fds from the parked list, do we keep the same
> > APIC/x2APIC id when hotplugging? Or can we actually hotplug with a
> > different id?
> 
> If I recall it right, it can be a different ID easily.

No, it cannot.  KVM doesn't provide a way for userspace to change the APIC ID of
a vCPU after the vCPU is created.  x2APIC flat out disallows changing the APIC ID,
and unless there's magic I'm missing, apic_mmio_write() => kvm_lapic_reg_write()
is not reachable from userspace.

The only way for userspace to set the APIC ID is to change vcpu->vcpu_id, and that
can only be done at KVM_VCPU_CREATE.

So, reusing a parked vCPU for hotplug must reuse the same APIC ID.  QEMU handles
this by stashing the vcpu_id, a.k.a. APIC ID, when parking a vCPU, and reuses a
parked vCPU if and only if it has the same APIC ID.  And because QEMU derives the
APIC ID from topology, that means all the topology CPUID leafs must remain the
same, otherwise the guest is hosed because it will send IPIs to the wrong vCPUs.

  static int do_kvm_destroy_vcpu(CPUState *cpu)
  {
    struct KVMParkedVcpu *vcpu = NULL;

    ...

    vcpu = g_malloc0(sizeof(*vcpu));
    vcpu->vcpu_id = kvm_arch_vcpu_id(cpu); <=== stash the APIC ID when parking
    vcpu->kvm_fd = cpu->kvm_fd;
    QLIST_INSERT_HEAD(&kvm_state->kvm_parked_vcpus, vcpu, node);
err:
    return ret;
  }

  static int kvm_get_vcpu(KVMState *s, unsigned long vcpu_id)
  {
    struct KVMParkedVcpu *cpu;

    QLIST_FOREACH(cpu, &s->kvm_parked_vcpus, node) {
        if (cpu->vcpu_id == vcpu_id) {  <=== reuse if APIC ID matches
            int kvm_fd;

            QLIST_REMOVE(cpu, node);
            kvm_fd = cpu->kvm_fd;
            g_free(cpu);
            return kvm_fd;
        }
    }

    return kvm_vm_ioctl(s, KVM_CREATE_VCPU, (void *)vcpu_id);
  }
