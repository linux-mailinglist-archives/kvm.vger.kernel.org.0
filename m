Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C653AA634
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 23:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbhFPViU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 17:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbhFPViT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 17:38:19 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E98C061768
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 14:36:12 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id v22so6707221lfa.3
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 14:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/WBzpjTlEIC+0YeR2sTj8EB49LrNZdqG2Ywu4ujpL/Q=;
        b=aZzmBV0zeDjsxdiwAUGxkQ+qlM+Z2+Xtp3RbQn+OWJ4LjuOhdlWs/AN9UfD9GEzEze
         YUFBJFHcn29V8Q3VenTkgY0YxugH4MZvDfK8ndTpnNPmqPA3k+sqN0Ulz7MY5mbiwHto
         FjI/Pl232CGxxpB+KT8ao/Dmjwto06Z0NqStvWEcXegANq5jQFrp3HLwTj+E+MDGMiEf
         aBGiWlQ73xBzoaXcbiA7YzxIBrhQssIbGOXsOYOdgQ1j4/iik+qrlYn/bnBYa9mgwWgn
         CKBX4YRnrVpvLj2VUlPRu8oZqoAlcn6bnqf28MIrG9eedG1kHAxxTI8D8bYJf99Kj0tb
         RkPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/WBzpjTlEIC+0YeR2sTj8EB49LrNZdqG2Ywu4ujpL/Q=;
        b=O+Kd0CJT5HQibftFWcO2lqz98QJ7WycPCW6UR8AfJAFjflln6UqBy/tsMo3GQPy4pj
         X96O5alLivDJh1L/eeTkRetOmO1T0dVRZNUGFKaDOPJjH/4ZmdCka/vgqEFqtjrR6bZQ
         Q2PZUmdQNEBCh2IeaQ/SENtXicZeb52z9OOpbP8SVnYGQvF8PlxSKozhK28ApbD7th8u
         CnorOBtPSrR2tatO3diG3F55kv9ubBCnXNQWyyZ0L/+eeq8DZm9Hbowe5uI0qJgGJwYe
         3QZFJoeF167v+xRrclbWOB9/rjbiwG/Is3fOsWyjaDwpWmdvs2/vRqArMhc+k3+6A63z
         iFMQ==
X-Gm-Message-State: AOAM530vKJ54BIlabhOi1QZm057VhcGw9I68vR4gRYRH8ZHLDVRjBWyY
        siK8ShDexMzc4w/EOl+ejMophg2BxHyDvo/lyuNhhg==
X-Google-Smtp-Source: ABdhPJy1IJHyCrFhtgtxVlR1G3P9sX7o1GbwIfDHAJj1N5NekBiATWZci4u9neAJFDfE+FpyK0UbWFHMwA/cWl+463Q=
X-Received: by 2002:a19:7601:: with SMTP id c1mr1361226lff.106.1623879370494;
 Wed, 16 Jun 2021 14:36:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210614212155.1670777-1-jingzhangos@google.com>
 <20210614212155.1670777-5-jingzhangos@google.com> <CA+EHjTybjrYL5KUJebmjvj_R5yULDxXsiPzn6f5f-y5HzQqM6A@mail.gmail.com>
In-Reply-To: <CA+EHjTybjrYL5KUJebmjvj_R5yULDxXsiPzn6f5f-y5HzQqM6A@mail.gmail.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 16 Jun 2021 16:35:59 -0500
Message-ID: <CAAdAUtgJ00h+QAMofm8WHOjgGVwTdzEQa4HW=g6MFzf3YgxqJQ@mail.gmail.com>
Subject: Re: [PATCH v9 4/5] KVM: selftests: Add selftest for KVM statistics
 data binary interface
To:     Fuad Tabba <tabba@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Fuad,

On Tue, Jun 15, 2021 at 3:03 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Jing,
>
> > +int main(int argc, char *argv[])
> > +{
> > +       int max_vm = DEFAULT_NUM_VM, max_vcpu = DEFAULT_NUM_VCPU, ret, i, j;
> > +       struct kvm_vm **vms;
> > +
> > +       /* Get the number of VMs and VCPUs that would be created for testing. */
> > +       if (argc > 1) {
> > +               max_vm = strtol(argv[1], NULL, 0);
> > +               if (max_vm <= 0)
> > +                       max_vm = DEFAULT_NUM_VM;
> > +       }
> > +       if (argc > 2) {
> > +               max_vcpu = strtol(argv[2], NULL, 0);
> > +               if (max_vcpu <= 0)
> > +                       max_vcpu = DEFAULT_NUM_VCPU;
> > +       }
> > +
> > +       /* Check the extension for binary stats */
> > +       ret = kvm_check_cap(KVM_CAP_BINARY_STATS_FD);
> > +       TEST_ASSERT(ret >= 0,
> > +                       "Binary form statistics interface is not supported");
>
> kvm_check_cap returns the value of KVM_CHECK_EXTENSION, which is 0 if
> unsupported (-ERROR on an error). The assertion should be for ret > 0.
>
> Made that change locally, and tested it with various configurations
> (vhe, nvhe), as well as kernel versions (with and without
> KVM_CAP_BINARY_STATS_FD), and it passes (or fails as expected).
> Without that fix and with a kernel that doesn't support
> KVM_CAP_BINARY_STATS_FD, it passes that assertion, but fails later at
> vcpu_stats_test().
>
> With that fixed:
> Tested-by: Fuad Tabba <tabba@google.com> #arm64
>
> Cheers,
> /fuad
>
>
Thanks for the review and testing. Will fix it.
> > +
> > +       /* Create VMs and VCPUs */
> > +       vms = malloc(sizeof(vms[0]) * max_vm);
> > +       TEST_ASSERT(vms, "Allocate memory for storing VM pointers");
> > +       for (i = 0; i < max_vm; ++i) {
> > +               vms[i] = vm_create(VM_MODE_DEFAULT,
> > +                               DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> > +               for (j = 0; j < max_vcpu; ++j)
> > +                       vm_vcpu_add(vms[i], j);
> > +       }
> > +
> > +       /* Check stats read for every VM and VCPU */
> > +       for (i = 0; i < max_vm; ++i) {
> > +               vm_stats_test(vms[i]);
> > +               for (j = 0; j < max_vcpu; ++j)
> > +                       vcpu_stats_test(vms[i], j);
> > +       }
> > +
> > +       for (i = 0; i < max_vm; ++i)
> > +               kvm_vm_free(vms[i]);
> > +       free(vms);
> > +       return 0;
> > +}
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 5c70596dd1b9..83c02cb0ae1e 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -2286,3 +2286,15 @@ unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size)
> >         n = DIV_ROUND_UP(size, vm_guest_mode_params[mode].page_size);
> >         return vm_adjust_num_guest_pages(mode, n);
> >  }
> > +
> > +int vm_get_stats_fd(struct kvm_vm *vm)
> > +{
> > +       return ioctl(vm->fd, KVM_GET_STATS_FD, NULL);
> > +}
> > +
> > +int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
> > +{
> > +       struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> > +
> > +       return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
> > +}
> > --
> > 2.32.0.272.g935e593368-goog
> >

Thank,
Jing
