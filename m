Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599C96ECC78
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 15:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbjDXNCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 09:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjDXNCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 09:02:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3144A3A93
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 06:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682341320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VZs+YpiXXIE6n/XU6TMZPlejs7Kb6MsmBc6LLaNqyFo=;
        b=PMFpNY8QiIVgsRgyw5adeiV1fh4OJoPLYQRfp30BuXRV/guGrb0IZbhR4Qq6PLpS18Ym5B
        ypV1ND9qOIMNE4PLZjs19YIzEcJzY0REIJlmktcKO+lRmTE7s00iFaVU3LMKcJap3gVdQ0
        lV2eOElQn2AfZ4qdjrpt6VwtIdZfCyY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-YhOavOQsOACU2oKVC0TpLA-1; Mon, 24 Apr 2023 09:01:57 -0400
X-MC-Unique: YhOavOQsOACU2oKVC0TpLA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 479A5884EC8;
        Mon, 24 Apr 2023 13:01:56 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3F04112131B;
        Mon, 24 Apr 2023 13:01:55 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-ppc@nongnu.org,
        qemu-arm@nongnu.org, qemu-s390x@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, danielhb413@gmail.com,
        clg@kaod.org, david@gibson.dropbear.id.au, groug@kaod.org,
        peter.maydell@linaro.org, chenhuacai@kernel.org,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [PATCH] kvm: Merge kvm_check_extension() and
 kvm_vm_check_extension()
In-Reply-To: <20230421163822.839167-1-jean-philippe@linaro.org>
Organization: Red Hat GmbH
References: <20230421163822.839167-1-jean-philippe@linaro.org>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 24 Apr 2023 15:01:54 +0200
Message-ID: <87jzy1v3gd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21 2023, Jean-Philippe Brucker <jean-philippe@linaro.org> wrote:

> The KVM_CHECK_EXTENSION ioctl can be issued either on the global fd
> (/dev/kvm), or on the VM fd obtained with KVM_CREATE_VM. For most
> extensions, KVM returns the same value with either method, but for some
> of them it can refine the returned value depending on the VM type. The
> KVM documentation [1] advises to use the VM fd:
>
>   Based on their initialization different VMs may have different
>   capabilities. It is thus encouraged to use the vm ioctl to query for
>   capabilities (available with KVM_CAP_CHECK_EXTENSION_VM on the vm fd)
>
> Ongoing work on Arm confidential VMs confirms this, as some capabilities
> become unavailable to confidential VMs, requiring changes in QEMU to use
> kvm_vm_check_extension() instead of kvm_check_extension() [2]. Rather
> than changing each check one by one, change kvm_check_extension() to
> always issue the ioctl on the VM fd when available, and remove
> kvm_vm_check_extension().
>
> Fall back to the global fd when the VM check is unavailable:
>
> * Ancient kernels do not support KVM_CHECK_EXTENSION on the VM fd, since
>   it was added by commit 92b591a4c46b ("KVM: Allow KVM_CHECK_EXTENSION
>   on the vm fd") in Linux 3.17 [3]. Support for Linux 3.16 ended only in
>   June 2020, but there may still be old images around.
>
> * A couple of calls must be issued before the VM fd is available, since
>   they determine the VM type: KVM_CAP_MIPS_VZ and KVM_CAP_ARM_VM_IPA_SIZE
>
> Does any user actually depend on the check being done on the global fd
> instead of the VM fd?  I surveyed all cases where KVM can return
> different values depending on the query method. Luckily QEMU already
> calls kvm_vm_check_extension() for most of those. Only three of them are
> ambiguous, because currently done on the global fd:
>
> * KVM_CAP_MAX_VCPUS and KVM_CAP_MAX_VCPU_ID on Arm, changes value if the
>   user requests a vGIC different from the default. But QEMU queries this
>   before vGIC configuration, so the reported value will be the same.
>
> * KVM_CAP_SW_TLB on PPC. When issued on the global fd, returns false if
>   the kvm-hv module is loaded; when issued on the VM fd, returns false
>   only if the VM type is HV instead of PR. If this returns false, then
>   QEMU will fail to initialize a BOOKE206 MMU model.
>
>   So this patch supposedly improves things, as it allows to run this
>   type of vCPU even when both KVM modules are loaded.
>
> * KVM_CAP_PPC_SECURE_GUEST. Similarly, doing this check on a VM fd
>   refines the returned value, and ensures that SVM is actually
>   supported. Since QEMU follows the check with kvm_vm_enable_cap(), this
>   patch should only provide better error reporting.
>
> [1] https://www.kernel.org/doc/html/latest/virt/kvm/api.html#kvm-check-extension
> [2] https://lore.kernel.org/kvm/875ybi0ytc.fsf@redhat.com/
> [3] https://github.com/torvalds/linux/commit/92b591a4c46b
>
> Suggested-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  include/sysemu/kvm.h     |  2 --
>  include/sysemu/kvm_int.h |  1 +
>  accel/kvm/kvm-all.c      | 26 +++++++++-----------------
>  target/i386/kvm/kvm.c    |  6 +++---
>  target/ppc/kvm.c         | 34 +++++++++++++++++-----------------
>  5 files changed, 30 insertions(+), 39 deletions(-)
>

(...)

> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index cf3a88d90e..eca815e763 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -1109,22 +1109,13 @@ int kvm_check_extension(KVMState *s, unsigned int extension)
>  {
>      int ret;
>  
> -    ret = kvm_ioctl(s, KVM_CHECK_EXTENSION, extension);
> -    if (ret < 0) {
> -        ret = 0;
> +    if (!s->check_extension_vm) {
> +        ret = kvm_ioctl(s, KVM_CHECK_EXTENSION, extension);
> +    } else {
> +        ret = kvm_vm_ioctl(s, KVM_CHECK_EXTENSION, extension);
>      }
> -
> -    return ret;
> -}
> -
> -int kvm_vm_check_extension(KVMState *s, unsigned int extension)
> -{
> -    int ret;
> -
> -    ret = kvm_vm_ioctl(s, KVM_CHECK_EXTENSION, extension);
>      if (ret < 0) {
> -        /* VM wide version not implemented, use global one instead */
> -        ret = kvm_check_extension(s, extension);
> +        ret = 0;
>      }
>  
>      return ret;
> @@ -2328,7 +2319,7 @@ static void kvm_irqchip_create(KVMState *s)
>   */
>  static int kvm_recommended_vcpus(KVMState *s)
>  {
> -    int ret = kvm_vm_check_extension(s, KVM_CAP_NR_VCPUS);
> +    int ret = kvm_check_extension(s, KVM_CAP_NR_VCPUS);
>      return (ret) ? ret : 4;
>  }
>  
> @@ -2480,6 +2471,7 @@ static int kvm_init(MachineState *ms)
>      }
>  
>      s->vmfd = ret;
> +    s->check_extension_vm = kvm_check_extension(s, KVM_CAP_CHECK_EXTENSION_VM);

Hm, it's a bit strange to set s->check_extension_vm by calling a
function that already checks for the value of
s->check_extension_vm... would it be better to call kvm_ioctl() directly
on this line?

I think it would be good if some ppc folks could give this a look, but
in general, it looks fine to me.

