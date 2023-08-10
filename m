Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CA1776CEF
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 02:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjHJAC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 20:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjHJAC2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 20:02:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEA9E74
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 17:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691625703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Po5OwqYn6EeqvIiscVlSRSdsOxz92jYH7zj6nASBvA=;
        b=NmGENJbdMWjVO65RYLSnmPEZh6I5qVdSDurLK48ENOu9JFw+NQKxCFblT3UPMVsX4ohodO
        09X7FP+xMRUzaer3U4tJVPHZV1QHDpOlG/rDz70DR1wZ9OHO8xndP7d0tyo2qzGEbl/NSQ
        QXjEUCR4UZJRJLfrwWLQ/AtkZxZXCOw=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-__VBucAVOMCWT-DUDZrtBg-1; Wed, 09 Aug 2023 20:01:41 -0400
X-MC-Unique: __VBucAVOMCWT-DUDZrtBg-1
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-48720ded9a2so124820e0c.3
        for <kvm@vger.kernel.org>; Wed, 09 Aug 2023 17:01:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691625700; x=1692230500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Po5OwqYn6EeqvIiscVlSRSdsOxz92jYH7zj6nASBvA=;
        b=F/g0DOsiH0clvju6oRZkut0umQKpKWRAycwtS4KWTYKdanBTpiC0noVhyV++3phOns
         8KiFZVc7bu6k7BCpJkUd8aMjVK5+HTBBEPrLH7UjdV2hDNTqLU64JJbgemrl4vDA5eja
         ZrdEVqjC/BBLvL3wUCC3kylfLH707Ao3dK7cc7jgaIb9QaipILqR7V85oAE5HfTncttm
         +cAEvk5AKY33djgPlggM4lTICcKs4eEF2+PO8SHxNYyoRNhgxKrvuqxEJNXjgaue/lld
         9xLNia9RZOazS0LDXyVQnaiZ9ceow1X+O6y+sqw9mhAI/R2Bwd5XkRx8cPZXKJwqbXnW
         IiIA==
X-Gm-Message-State: AOJu0Yy9E3YeKymXjUGfkWWTVsee96lUxFscSRFx7lU6Na8jmpNEiOs6
        tdgIMhW37VC0b7Mt0jZ6GTELa2w3DtZg+9uP+1UI5V8SmJrExPQ+LdlLtVszyxmO4TPwXib2Ztq
        21NTMnXTvquvvfpFrr7nTvb0an5lk
X-Received: by 2002:a67:fc95:0:b0:446:e948:ebd4 with SMTP id x21-20020a67fc95000000b00446e948ebd4mr343998vsp.21.1691625700692;
        Wed, 09 Aug 2023 17:01:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IES9sngfvEeUDJZps2SC8llAQiHiv31cJjTpNUOYZEKkNvhF6lGp9Iv1OMeP5TH4nIG4W7XVyTGd7ZSafAcdoI=
X-Received: by 2002:a67:fc95:0:b0:446:e948:ebd4 with SMTP id
 x21-20020a67fc95000000b00446e948ebd4mr343992vsp.21.1691625700455; Wed, 09 Aug
 2023 17:01:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-5-weijiang.yang@intel.com> <ZM1C+ILRMCfzJxx7@google.com>
 <0655c963-78e5-62c9-50af-20d9de8a1001@intel.com>
In-Reply-To: <0655c963-78e5-62c9-50af-20d9de8a1001@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 10 Aug 2023 02:01:29 +0200
Message-ID: <CABgObfbvr8F8g5hJN6jn95m7u7m2+8ACkqO25KAZwRmJ9AncZg@mail.gmail.com>
Subject: Re: [PATCH v5 04/19] KVM:x86: Refresh CPUID on write to guest MSR_IA32_XSS
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
        chao.gao@intel.com, binbin.wu@linux.intel.com,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 9, 2023 at 10:56=E2=80=AFAM Yang, Weijiang <weijiang.yang@intel=
.com> wrote:
> > I'm pretty sure I've advocated for the exact opposite in the past, i.e.=
 argued
> > that KVM's ABI is to not enforce ordering between KVM_SET_CPUID2 and KV=
M_SET_MSR.
> > But this is becoming untenable, juggling the dependencies in KVM is com=
plex and
> > is going to result in a nasty bug at some point.
> >
> > For this series, lets just tighten the rules for XSS, i.e. drop the hos=
t_initated
> > exemption.  And in a parallel/separate series, try to do a wholesale cl=
eanup of
> > all the cases that essentially allow userspace to do KVM_SET_MSR before=
 KVM_SET_CPUID2.
> OK, will do it for this series and investigate for other MSRs.
> Thanks!

Remember that, while the ordering between KVM_SET_CPUID2 and
KVM_SET_MSR must be enforced(*), the host_initiated path must allow
the default (generally 0) value.

Paolo

(*) this means that you should check guest_cpuid_has even if
host_initiated =3D=3D true.

