Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1791074B5ED
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 19:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjGGRmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 13:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjGGRmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 13:42:09 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71D110CE
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 10:42:08 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id 71dfb90a1353d-47560c8e057so821847e0c.1
        for <kvm@vger.kernel.org>; Fri, 07 Jul 2023 10:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688751728; x=1691343728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oBBp97IJ5nf9KBuNgeMGVGX8CSgQfVZqr3i4Yqkacbo=;
        b=rvoMu04yLOtNn/6CESJMOwME8Dcw0O2f3UjvEt1QsTZR69RYWgX+107drg4dSddzE5
         R9NYxGUvfHtSD3LvqyKD3Q1WtTslVUrYbyzJgE8zPDNYSkfTpmzXoW6fYnjcs/al257o
         ERNToZPrBrGcmFSDM2nfSjb8xMdzP1WWpSO7APhWexpgJgwm+kFQChIEHYWvZ7UErRa9
         zuQ7Vf1GlPThmLhdpR/uC9fQvOS2HPgPbcw6MoQoamDYucy3KP+NocgPmRrQVInqAnE6
         +uLy3aw+o+IORLqS9uR1b9n4wPZ1+uYloLAJYTDziIkw3zU6BcnTNdfrYnB2Z9gEy5uS
         WaqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688751728; x=1691343728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oBBp97IJ5nf9KBuNgeMGVGX8CSgQfVZqr3i4Yqkacbo=;
        b=NKC88jtnodpSoxNiRLGjAXQvYeHHrYl+sjxPYhmkKTv5ykYQeAZOZZRao7Dn7WnBDv
         1G3tjhPqbDRsb7LofQbBgsP4oXYjeWmpDW5sdGtT3/+rh9Lu9oGcOLh7z+jT4crU9izd
         EpfA50qm5A/D5jjENg559iWprq2slW/Ho4f8+9hhR2WWRM1IN14Ri5RESSFsLDg1ab7l
         fZz4PSnsH3Dg8XUPuLjZmy/XDdMlwOukmLOCZga0DzUb7bNodMNx4Ofz4yKjNlIKcIPl
         wMfDo3CAiYbuctj3DNCX/wHXkmKmZcx6mVRkb+Spu118rzmqjE96kwpImKFKG8zFoh9F
         vHqQ==
X-Gm-Message-State: ABy/qLYC3aU5rGHFdk2R9RPmO+V/L6xAlBqdjmR5FSJETdNqfhc8Ll1/
        +Tfhu9hs9hcse5Gn2qhQsdST5nKg6nz7rP4z/Bodug==
X-Google-Smtp-Source: APBJJlEOPbOEinA2SbMLKyZ96JinCbahFvj1DWsVPsF/X3Lnt5roeqZ6dujCD1qkpYtzYrJjnccgel0Rjm1nQj8eAtY=
X-Received: by 2002:a1f:c151:0:b0:47e:677a:e7fc with SMTP id
 r78-20020a1fc151000000b0047e677ae7fcmr3907044vkf.6.1688751727821; Fri, 07 Jul
 2023 10:42:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-11-amoorthy@google.com>
 <ZIoiLGotFsDDvRN3@google.com>
In-Reply-To: <ZIoiLGotFsDDvRN3@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Fri, 7 Jul 2023 10:41:32 -0700
Message-ID: <CAF7b7mpisSor9uYz4oT9b4oLpmrNL1ZEqFGQhrFgSFeeVK7VuQ@mail.gmail.com>
Subject: Re: [PATCH v4 10/16] KVM: x86: Implement KVM_CAP_NOWAIT_ON_FAULT
To:     Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023 at 1:25=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> > -static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fa=
ult *fault)
> > +static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu,
> > +                          struct kvm_page_fault *fault,
> > +                          bool nowait)
>
> More booleans!?  Just say no!  And in this case, there's no reason to pas=
s in a
> flag, just handle this entirely in __kvm_faultin_pfn().

Ah, thanks: that extra parameter is a holdover from forever ago where
"nowait" was a special thing that was read by handle_error_pfn(). Done.
