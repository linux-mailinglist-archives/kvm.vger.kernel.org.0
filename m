Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1B277C44F
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 02:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbjHOAHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 20:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbjHOAHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 20:07:05 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E8C11D
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 17:07:04 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id 71dfb90a1353d-48727371106so2463293e0c.3
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 17:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692058024; x=1692662824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NEb/LALV6ac5FnGK5WrJgICv/9PyQoMajfPza96VUQo=;
        b=DwuVEz4JSsZHVlYPo5/0uGw0vF6PVEoFMndDCjy7Xze8LDueMPDF9Pp7ZkZnY/d0CT
         JCtfkLzUhpnNNou4G69uaoUoIb19o5DY40LlyrM8fuPvMOt2qhnyo8hlc3N+E6tUJ835
         M+KQxYv3ww1vSZ1tzHs9to2SbY4kkNJN54lDZtJxmnZcBCOWw9g/JhJOvh943aLBWEyF
         ZaobUvc2lF/zTSryWfeglBni8Sz0fsOis7UtmZlKZdgFIGuy6cBhJmP9v/BuVPS+I4Zk
         1OB5Y2dW/33DPFw709/6rLrZihjpghiic6AXuWItBj/bRxVNey63LhJHcOayLG5nUyzo
         IHsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692058024; x=1692662824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NEb/LALV6ac5FnGK5WrJgICv/9PyQoMajfPza96VUQo=;
        b=lu4rHW8UYefScNFyvZCOQJJpRCZmrn8SzcxeGQC6YrFiQtQtDeWXKR1uIZUv1icwUM
         5UxGvOL40xsUDpzIS2mRNkUkMFZeRjp9PNnKvBEvY5zfYJBsqqXbQkx1VFAMx2kFnrUd
         mwZWVgi1vMfSwAXPNclt+J5Gw7S34LeD7OBdNzF0QltaCKics5bNKs+K67E0thT+S81w
         EurAnYsVSbV1hOoQFRW4gnf/95CSAfynx+3fbR6PgmoOoif8SIK0WiZ91AGzcPsdsAWz
         kyR/khP+MCObS8u49Rq/3R/hTs/uw6FyU/kmyPSzlDxvxFZ/W44YMinCx8pLEVwJtC8p
         mrqg==
X-Gm-Message-State: AOJu0Yw1r3q1BM0ZtrBOJ4A+J0yrCEIQqXpvEgixZPdZzJG7dkh15FF1
        z9Lr+s3WZaMAYV7E3wbf9JcGA1UvSK5939hQ+Y4SOg==
X-Google-Smtp-Source: AGHT+IHsIHwWXyqKbw7AFdpj6pk0PdEeqqURN+HPrG/ZUKB6E/6g9lCm3ByHYeozRrG1lCRfMQ1nz8sfwhXku6E9G68=
X-Received: by 2002:a1f:ea44:0:b0:487:e8f1:a2c1 with SMTP id
 i65-20020a1fea44000000b00487e8f1a2c1mr7836670vkh.8.1692058023805; Mon, 14 Aug
 2023 17:07:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com> <CAF7b7mqfkLYtWBJ=u0MK7hhARHrahQXHza9VnaughyNz5_tNug@mail.gmail.com>
 <ZNpsCngiSjISMG5j@google.com>
In-Reply-To: <ZNpsCngiSjISMG5j@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Mon, 14 Aug 2023 17:06:27 -0700
Message-ID: <CAF7b7mo0gGGhv9dSFV70md1fNqMvPCfZ05VawPOB=xFkaax8AA@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
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
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14, 2023 at 11:01=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> What is/was the error?  It's probably worth digging into; "static inline"=
 should
> work just fine, so there might be something funky elsewhere that you're p=
apering
> over.

What I get is

> ./include/linux/kvm_host.h:2298:20: error: function 'kvm_handle_guest_uac=
cess_fault' has internal linkage but is not defined [-Werror,-Wundefined-in=
ternal]
> static inline void kvm_handle_guest_uaccess_fault(struct kvm_vcpu *vcpu,
>                    ^
> arch/x86/kvm/mmu/mmu.c:3323:2: note: used here
>         kvm_handle_guest_uaccess_fault(vcpu, gfn_to_gpa(fault->gfn), PAGE=
_SIZE,
>         ^
> 1 error generated.

(mmu.c:3323 is in kvm_handle_error_pfn()). I tried shoving the
definition of the function from kvm_main.c to kvm_host.h so that I
could make it "static inline": but then the same "internal linkage"
error pops up in the kvm_vcpu_read/write_guest_page() functions.

Btw, do you actually know the size of the union in the run struct? I
started checking it but stopped when I realized that it includes
arch-dependent structs.
