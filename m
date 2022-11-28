Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68BD563B167
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 19:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbiK1Sd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 13:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbiK1Sc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 13:32:58 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6B125E9
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 10:30:38 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 82so3229060pgc.0
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 10:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aLEoNq9y1G78EFIkjhdD6/OWpioH5mP6NdxcCtNN9B8=;
        b=iC2mBBh0WNKoAP1S9mjsUvuV6MtM8Cyeh6pG2LugoWOxV1HK0YcMLZX3Ep92TT3CAo
         vRKJJhGdWiXEnuNbP0euaE1bDGbm8y0MgobHGAGAL0Xep736ScwE92gFpEZLTJKHHHUe
         vXNAmF9lA8ZsZZ6Y1b4Zmc1hR7mEuU9cXZKa5T66x+xCGa46HBLtrpo/M/GLcjKFQRSZ
         k5GFyjIotZZiESFruqXuaRUQj2lIj5j/OPXc6Fr3Ze/Fv+bU7NxCWg/6VTZSvN991x0t
         N9/qM50/XLhKOvwoHTAvvXglxciyL+Eu2ouNPd35Wf32TsPoIdMxm1aMCSS7XM7HHQ11
         gZ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aLEoNq9y1G78EFIkjhdD6/OWpioH5mP6NdxcCtNN9B8=;
        b=TlmzJO/ypBikRwADNWN22SWl5QZp8pxlIPl0JMWILMwftIDmeEtSTPHi0r9OpIPS1C
         2IksrBkyRLzDO6W7S7zLY9YXZ1WmiZ5D3wCyL7q2vwUk33pSRfr7Z4HChJ/Chn80B2DC
         2IwJ6/PAI0UcoIPsGfJLEkdWtTS0UPo3maG/FJttIkTjq45deV0LOqDOeIs8CuB5Hblp
         Wb/Lk6fkme5p1VKZnLzcA2DXUdIIik0DiBkAYxMDjALJhCny2hVGepLEmNZ614iqE6Vo
         0VaUAau5ne3KXbejvw3DieolPIN4yKyOj9cocDldeVwqySV30MqBrFQu1N87PXN1bI3W
         Efig==
X-Gm-Message-State: ANoB5pnU7mmp81OjeupTjhxwxJ1XiHsKHBB7bSVqh+7yFAGVu4y6d/63
        Yk6tydU1+3SQlHzssoX2PI8VOA==
X-Google-Smtp-Source: AA0mqf7YC8b5f8pWfjaUB1/Nf1xae8tCM9bv+SFl0lBIkJKN3hOD5T4yS7SZphMUEFZivDYGIpfcNg==
X-Received: by 2002:a63:1a5a:0:b0:456:f79e:4e95 with SMTP id a26-20020a631a5a000000b00456f79e4e95mr27680039pgm.607.1669660237781;
        Mon, 28 Nov 2022 10:30:37 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902654600b00182d25a1e4bsm9040924pln.259.2022.11.28.10.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 10:30:37 -0800 (PST)
Date:   Mon, 28 Nov 2022 18:30:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Javier Martinez Canillas <javierm@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Sergio Lopez Pascual <slp@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: Mark KVM_SET_MEMORY_REGION and
 KVM_SET_MEMORY_ALIAS as obsoleted
Message-ID: <Y4T+SY9SZIRFBdBM@google.com>
References: <20221119085632.1018994-1-javierm@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221119085632.1018994-1-javierm@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 19, 2022, Javier Martinez Canillas wrote:
> Other ioctl such as KVM_ARM_SET_DEVICE_ADDR have a (deprecated) next to it
> which makes it easier to determine that is deprecated. Do the same for the
> ioctls that have been obsoleted.
> 
> Suggested-by: Sergio Lopez Pascual <slp@redhat.com>
> Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
> ---
> 
>  Documentation/virt/kvm/api.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index eee9f857a986..c17bac32d25c 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -272,7 +272,7 @@ the VCPU file descriptor can be mmap-ed, including:
>    KVM_CAP_DIRTY_LOG_RING, see section 8.3.
>  
>  
> -4.6 KVM_SET_MEMORY_REGION
> +4.6 KVM_SET_MEMORY_REGION (obsoleted)

I realize the existing doc entry and include/uapi/linux/kvm.h says these are
"obsolete", but both of these are more than just obsolete since KVM no longer
supports them.  There's even a different blurb that states they are deprecated.

E.g. KVM_{CREATE,GET,SET}_PIT are good examples of obsolete ioctls; they've been
supplanted by newer variants, but KVM still supports the old ones too.

Alternatively (to marking them deprecated), can we completely remove all references
to VM_SET_MEMORY_REGION and KVM_SET_MEMORY_ALIAS?  The cascading updates in api.rst
will be painful, but it's one-time pain.

E.g. can we do something like this?

---
 Documentation/virt/kvm/api.rst  | 27 ---------------------------
 arch/x86/include/uapi/asm/kvm.h |  8 --------
 include/uapi/linux/kvm.h        | 12 ++----------
 3 files changed, 2 insertions(+), 45 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index eee9f857a986..85a5b12eb017 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -272,18 +272,6 @@ the VCPU file descriptor can be mmap-ed, including:
   KVM_CAP_DIRTY_LOG_RING, see section 8.3.
 
 
-4.6 KVM_SET_MEMORY_REGION
--------------------------
-
-:Capability: basic
-:Architectures: all
-:Type: vm ioctl
-:Parameters: struct kvm_memory_region (in)
-:Returns: 0 on success, -1 on error
-
-This ioctl is obsolete and has been removed.
-
-
 4.7 KVM_CREATE_VCPU
 -------------------
 
@@ -368,17 +356,6 @@ see the description of the capability.
 Note that the Xen shared info page, if configured, shall always be assumed
 to be dirty. KVM will not explicitly mark it such.
 
-4.9 KVM_SET_MEMORY_ALIAS
-------------------------
-
-:Capability: basic
-:Architectures: x86
-:Type: vm ioctl
-:Parameters: struct kvm_memory_alias (in)
-:Returns: 0 (success), -1 (error)
-
-This ioctl is obsolete and has been removed.
-
 
 4.10 KVM_RUN
 ------------
@@ -1377,10 +1354,6 @@ the memory region are automatically reflected into the guest.  For example, an
 mmap() that affects the region will be made visible immediately.  Another
 example is madvise(MADV_DROP).
 
-It is recommended to use this API instead of the KVM_SET_MEMORY_REGION ioctl.
-The KVM_SET_MEMORY_REGION does not allow fine grained control over memory
-allocation and is deprecated.
-
 
 4.36 KVM_SET_TSS_ADDR
 ---------------------
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index c6df6b16a088..e48deab8901d 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -53,14 +53,6 @@
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
 
-struct kvm_memory_alias {
-	__u32 slot;  /* this has a different namespace than memory slots */
-	__u32 flags;
-	__u64 guest_phys_addr;
-	__u64 memory_size;
-	__u64 target_phys_addr;
-};
-
 /* for KVM_GET_IRQCHIP and KVM_SET_IRQCHIP */
 struct kvm_pic_state {
 	__u8 last_irr;	/* edge detection */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7fea12369245..b8e905ac9d0d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -86,13 +86,6 @@ struct kvm_debug_guest {
 /* *** End of deprecated interfaces *** */
 
 
-/* for KVM_CREATE_MEMORY_REGION */
-struct kvm_memory_region {
-	__u32 slot;
-	__u32 flags;
-	__u64 guest_phys_addr;
-	__u64 memory_size; /* bytes */
-};
 
 /* for KVM_SET_USER_MEMORY_REGION */
 struct kvm_userspace_memory_region {
@@ -1443,15 +1436,14 @@ struct kvm_vfio_spapr_tce {
 /*
  * ioctls for VM fds
  */
-#define KVM_SET_MEMORY_REGION     _IOW(KVMIO,  0x40, struct kvm_memory_region)
+#define KVM_DEPRECATED_SET_MEMORY_REGION     _IOW(KVMIO,  0x40)
 /*
  * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
  * a vcpu fd.
  */
 #define KVM_CREATE_VCPU           _IO(KVMIO,   0x41)
 #define KVM_GET_DIRTY_LOG         _IOW(KVMIO,  0x42, struct kvm_dirty_log)
-/* KVM_SET_MEMORY_ALIAS is obsolete: */
-#define KVM_SET_MEMORY_ALIAS      _IOW(KVMIO,  0x43, struct kvm_memory_alias)
+#define KVM_DEPRECATED_SET_MEMORY_ALIAS      _IOW(KVMIO,  0x43)
 #define KVM_SET_NR_MMU_PAGES      _IO(KVMIO,   0x44)
 #define KVM_GET_NR_MMU_PAGES      _IO(KVMIO,   0x45)
 #define KVM_SET_USER_MEMORY_REGION _IOW(KVMIO, 0x46, \

base-commit: 7ca560b50ba9a13150ccf2768ae1f53cd6c735c1
-- 

