Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCD0727EBA
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 13:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235670AbjFHL3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 07:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbjFHL3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 07:29:52 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9552718
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 04:29:47 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id 71dfb90a1353d-463fdee669cso377612e0c.0
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 04:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686223786; x=1688815786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ti5W00fHo5+54ZqpdE6ywmJj9WVEs3HQLqx+j7roPaM=;
        b=j9UYTd2O2XcooRATGj467HxZMPDB0Cg9aL5LSEvNsyNB/167ogbccoVHPhVnlpSZWG
         DGwjl1hc1Ht3q63sDOZhBv2Y45SGTynRUYRh5yFf3RlUig17UAEktGlYlnqcm4oQJnu9
         EwkDn+GxHlJgT2KLU1Fm8mKpcSDSJ1ZetNRe3im8cpFlisVRRXkPIrdCxhkQ48MOZ8En
         0jzTx3+HB2NWZTUCIH3hhTe8lbbnFOLk86qxbqhL/NKgdUY4Oxj1jox+hmOQNH8nAwJH
         0GxW+q4EVMUgSH0pehUz4k0JBJDdxb71mDBqBr/0pTE4JZ7YLQWpu9+OWP/1Z7mOFYlf
         uHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686223786; x=1688815786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ti5W00fHo5+54ZqpdE6ywmJj9WVEs3HQLqx+j7roPaM=;
        b=NzUKv6znRojpLb4hNcx2znW8Yv8hFDZAAh6JySlgDseoRdtmjtHZl2/HGn1kY21C8A
         Bq0LtGYUP7nJsTFhyJoFSes9WBnT2LCbiJbaO9NJglxlsLXp3fUXEv2+LlvjrJ7qLJ9v
         jXwCp4UnmHSTW29dK3ANN75KKoH1oXu0HQA21weYXqQudSar3ZaRRqT8h3BzC2bopxWH
         cs64a73SK1yn1IsMEZXylW+a0vxnxB/du5MUcI8MzkVApXB64bGGOo2QY3j/d7XTT8hA
         skx65MpMXnDdvFkw8KccqyZhUVDc3FJm5cShlZc15dWhsHLyvfAbhLGtpfwKSuxAliNu
         y9uw==
X-Gm-Message-State: AC+VfDypCKwuzUrlg4N/UsTQGz+APc0FW86JMbmV1Ep6Am8fzIBmOoN3
        tr90nQisMs2ERk7n1l1RMWcdlLFyeHcHDddmTxcKdQ==
X-Google-Smtp-Source: ACHHUZ5zcnDOZfoYJbivv3/58L+IR70zNlCg7fYw4RIRpY5qWv0mfo+fyDF1mW7Z5LjTsSSYSKdgWltSjIajTRyIdnE=
X-Received: by 2002:a1f:4103:0:b0:43f:e623:952 with SMTP id
 o3-20020a1f4103000000b0043fe6230952mr837973vka.2.1686223786516; Thu, 08 Jun
 2023 04:29:46 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <a7fc71f5d30676e9360f3db040feb7e6ac18203f.1685333728.git.isaku.yamahata@intel.com>
 <CAAYXXYzR6JZq8OOD2qqC_vVGiCa3e5KmZZ+36YffGW6JFK4+Hw@mail.gmail.com>
In-Reply-To: <CAAYXXYzR6JZq8OOD2qqC_vVGiCa3e5KmZZ+36YffGW6JFK4+Hw@mail.gmail.com>
From:   Erdem Aktas <erdemaktas@google.com>
Date:   Thu, 8 Jun 2023 04:29:35 -0700
Message-ID: <CAAYXXYyUbqjmrezTw=p_yBkkB-o9H-Xg_J5rBCe1CXUpF5PM+A@mail.gmail.com>
Subject: Re: [PATCH v14 055/113] KVM: TDX: TDP MMU TDX support
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        Vishal Annapurve <vannapurve@google.com>
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

On Sun, May 28, 2023 at 9:21=E2=80=AFPM <isaku.yamahata@intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> +static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> +                                      enum pg_level level, kvm_pfn_t pfn=
)
> +{
> +       int tdx_level =3D pg_level_to_tdx_sept_level(level);
> +       struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
> +       struct tdx_module_output out;
> +       gpa_t gpa =3D gfn_to_gpa(gfn);
> +       hpa_t hpa =3D pfn_to_hpa(pfn);
> +       hpa_t hpa_with_hkid;
> +       u64 err;
> +
> +       /* TODO: handle large pages. */
> +       if (KVM_BUG_ON(level !=3D PG_LEVEL_4K, kvm))
> +               return -EINVAL;
> +
> +       if (unlikely(!is_hkid_assigned(kvm_tdx))) {
> +               /*
> +                * The HKID assigned to this TD was already freed and cac=
he
> +                * was already flushed. We don't have to flush again.
> +                */
> +               err =3D tdx_reclaim_page(hpa, false, 0);
> +               if (KVM_BUG_ON(err, kvm))
> +                       return -EIO;
> +               tdx_unpin(kvm, pfn);
> +               return 0;
> +       }
> +
> +       do {
> +               /*
> +                * When zapping private page, write lock is held. So no r=
ace
> +                * condition with other vcpu sept operation.  Race only w=
ith
> +                * TDH.VP.ENTER.
> +                */
> +               err =3D tdh_mem_page_remove(kvm_tdx->tdr_pa, gpa, tdx_lev=
el, &out);
> +       } while (unlikely(err =3D=3D TDX_ERROR_SEPT_BUSY));
> +       if (KVM_BUG_ON(err, kvm)) {
> +               pr_tdx_error(TDH_MEM_PAGE_REMOVE, err, &out);
> +               return -EIO;
> +       }
> +
> +       hpa_with_hkid =3D set_hkid_to_hpa(hpa, (u16)kvm_tdx->hkid);
> +       do {
> +               /*
> +                * TDX_OPERAND_BUSY can happen on locking PAMT entry.  Be=
cause
> +                * this page was removed above, other thread shouldn't be
> +                * repeatedly operating on this page.  Just retry loop.
> +                */
> +               err =3D tdh_phymem_page_wbinvd(hpa_with_hkid);
> +       } while (unlikely(err =3D=3D (TDX_OPERAND_BUSY | TDX_OPERAND_ID_R=
CX)));
> +       if (KVM_BUG_ON(err, kvm)) {
> +               pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
> +               return -EIO;
> +       }


It seems like when the TD is destroyed, all the TD private pages are
removed with tdx_reclaim_page which also clears the page with
movdir64b instruction. But when the page is removed while the TD is
alive (in this case), the page content is never cleared with movdir64b
which causes any poisoned cache line to be consumed by the host
resulting in #MC exceptions in the host context.

We should clear the page before returning it back to the free pool by
calling tdx_clear_page((unsigned long)__va(hpa)) here.

>
> +       tdx_unpin(kvm, pfn);
> +       return 0;
> +}
> +
>
