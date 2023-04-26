Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBEC6EFB65
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 21:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbjDZT6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 15:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjDZT6Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 15:58:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFECD2
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682539048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B8Xh5WSnnf9Gc9BX2PFh/bbA5JFb7APsYGklshAUxH4=;
        b=Zm7RdigIYsK7/9EVWm2b7OLvEXQVOwJGD/ztLAtJrccHJATItkX2/I57rwi+4cCX6On3Ai
        fNf/+RZmr+cQcj4dAclEHlL0GNNpUNxMnR+uX30dkQ4JELa43WG6UR7oSndMSxfpi1mTgL
        dPRbgfHXeOyuuJ9BBaOf5i9MQZ2Hd6k=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-zXlir0BQNmCzih6cMqSlkA-1; Wed, 26 Apr 2023 15:57:25 -0400
X-MC-Unique: zXlir0BQNmCzih6cMqSlkA-1
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-7714f81211aso2472816241.3
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:57:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682539045; x=1685131045;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B8Xh5WSnnf9Gc9BX2PFh/bbA5JFb7APsYGklshAUxH4=;
        b=Pj5iwGpabLGgrQyz/eVTOu+2sVFDMtFlc7X+4g6O11nGJjbWm72TK/LkRMrqtbbvbF
         NR35GnPPOsP25a13jr/R3+p27wkpTQbPK0ZPGwvTegMRRebEQ0D2gbrIHfohDsO4X58I
         6LBpRpYKvNdu9V8kWeMXdTjn0kFT+mhHMnfpybh+aV80vnU+5qYGP9t+4cpIIWUbHAgC
         0obFGT0EaNVUTvwAIbz8klO1fwXZ6c8Lc6ioutOoGRerbGGyZRC9dsveDV0B6j5U8Wxt
         mERWSjkZs20LEY32CkO8Wk3hz5JkSJNks4+SESFPOPcOx4f6mm/PdYYm8+HPhU2HnBg8
         F2HA==
X-Gm-Message-State: AAQBX9eiGlOExsVfJ3XkhegyyXR+1UC+ieeraufctKVSqN049Q3nlOVn
        NCMxJg+6sewfog9yHdZevovEBfnEu84PQ3t9QmSgvb2VYjnX2U8utPXwa14wpRr0jMZIetFRaIW
        ybQMdJteyezoCzGYvx+M9eDpqGF/F+OQUUqWjTss=
X-Received: by 2002:a67:fd55:0:b0:426:2a37:4a6b with SMTP id g21-20020a67fd55000000b004262a374a6bmr9751799vsr.25.1682539044879;
        Wed, 26 Apr 2023 12:57:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350a77YLGsVUF4DnO7UeE7LbQwM9vHQ9Qskb2xsJ4hqvUQNyt4D1gehqD3JWCkoQKQk4ps6kAgSghwI7ZMJYq79E=
X-Received: by 2002:a67:fd55:0:b0:426:2a37:4a6b with SMTP id
 g21-20020a67fd55000000b004262a374a6bmr9751792vsr.25.1682539044580; Wed, 26
 Apr 2023 12:57:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230424173529.2648601-1-seanjc@google.com> <20230424173529.2648601-7-seanjc@google.com>
In-Reply-To: <20230424173529.2648601-7-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 26 Apr 2023 21:57:13 +0200
Message-ID: <CABgObfYHrBf=NM4+ay8zd1BzkQtgM-WcbkZwdAb2TnrwoEXP0A@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: VMX changes for 6.4
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023 at 7:35=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> KVM VMX changes for 6.4.  A few cleanups and a few fixes, nothing super
> interesting or urgent.  IMO, the most notable part of this pull request i=
s
> that ENCLS is actually allowed in compatibility mode. :-)
>
> The following changes since commit d8708b80fa0e6e21bc0c9e7276ad0bccef73b6=
e7:
>
>   KVM: Change return type of kvm_arch_vm_ioctl() to "int" (2023-03-16 10:=
18:07 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.4
>
> for you to fetch changes up to 4984563823f0034d3533854c1b50e729f5191089:
>
>   KVM: nVMX: Emulate NOPs in L2, and PAUSE if it's not intercepted (2023-=
04-11 09:35:49 -0700)

Pulled (but not pushed yet), thanks.

Paolo

> ----------------------------------------------------------------
> KVM VMX changes for 6.4:
>
>  - Fix a bug in emulation of ENCLS in compatibility mode
>
>  - Allow emulation of NOP and PAUSE for L2
>
>  - Misc cleanups
>
> ----------------------------------------------------------------
> Binbin Wu (1):
>       KVM: VMX: Use is_64_bit_mode() to check 64-bit mode in SGX handler
>
> Sean Christopherson (1):
>       KVM: nVMX: Emulate NOPs in L2, and PAUSE if it's not intercepted
>
> Yu Zhang (2):
>       KVM: nVMX: Remove outdated comments in nested_vmx_setup_ctls_msrs()
>       KVM: nVMX: Add helpers to setup VMX control msr configs
>
>  arch/x86/kvm/vmx/nested.c | 112 ++++++++++++++++++++++++++++++----------=
------
>  arch/x86/kvm/vmx/sgx.c    |   4 +-
>  arch/x86/kvm/vmx/vmx.c    |  15 +++++++
>  3 files changed, 91 insertions(+), 40 deletions(-)
>

