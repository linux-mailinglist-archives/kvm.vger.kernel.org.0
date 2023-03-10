Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B7E6B32D1
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 01:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjCJAhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 19:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCJAhD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 19:37:03 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003FE1009F7
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 16:37:02 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id v13so3879005ybu.0
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 16:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678408622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WAzBBc9wHE3faAQaHPnJrzBYGicXWfO6YwSCnEUYwO8=;
        b=DP801WyB9U7zGzT/wgHu2FqpcApFrv30zcfazOvaL/QbMhY+5UMOiBKi9iletv3b2+
         BdsHI56hT7iu4nY0wvzW2XE3B5pG6LV7vevijrN9KvG67biMrDWkTxPH4MVQvoahknWl
         NMzP6AqxUaxgSJOU78wmtxBCot39quUVXNJ0iDWAA0HdPCdUM1Etlm6A+kMs19wjT1TN
         HD1wUzxcmQBK8OUmtH5OWX+Cg74EuyKV6DplhR6tktVccIUbNCnmrjLntJv+h+GSrYV4
         WAbVX3Y9XYnsicXx4KSAsJmnRsn7XLeBWlmTnnJR+XwvkPn+ocN7zpdZwMi5v4nVxJNm
         viVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678408622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WAzBBc9wHE3faAQaHPnJrzBYGicXWfO6YwSCnEUYwO8=;
        b=IfuBeIQ1uQ51OXtcZFwxz89YmlFt85vPAL3sZOgeyAJe5cvWl4RfSf/DYLKSH4DjeA
         +aRtuM0bii8tMivhn6z1AJu/JIX3WiqmEo75o9NMBYC15SX4YNigRy33MU/zIX+Ydx2E
         Fc2knx8CItS0SuKaVaX/+uGPD+AfYGWQrLKJcnu2RmlfMMBQf+6z8UmSxn5cN5kKnCxp
         yV7/T4LZwd5Fk90eB3mBv6hwr3xbxcrkOV55ymUCuvha9lcskDyBtLDAIXxMZSTpsS7B
         xKnmWUQA+zPlT6H26R9hYEMIb/HYOvnBZ1rHVNpc5a1W+FthPUjASuE7wXMc9TUolay3
         quAg==
X-Gm-Message-State: AO0yUKXCAvtVq3+lBjCbC8qYExZ+Mp1hW/KEnWAaRaUItO9N6Fy0Q2lx
        SO00tJqYg4W5zsSzI+De/hU/ic7NyCTpyIM+oToRcw==
X-Google-Smtp-Source: AK7set8Yeo5N8u/LejHHlCHchZWu+69KL1Q3WfPtOJGkyHp006nurs5zxDXdmyxrnnCzgJcZSC8U8vwsygq9QuT+t3g=
X-Received: by 2002:a25:9d06:0:b0:a58:7139:cf85 with SMTP id
 i6-20020a259d06000000b00a587139cf85mr14574043ybp.13.1678408622000; Thu, 09
 Mar 2023 16:37:02 -0800 (PST)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-4-vipinsh@google.com>
 <ZAp4Tb8MYoggn/Rb@google.com>
In-Reply-To: <ZAp4Tb8MYoggn/Rb@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 9 Mar 2023 16:36:26 -0800
Message-ID: <CAHVum0ffHpUCyZTVUYwk4AT1hYqrts6_ErrMo1wrFSFpDZNcEA@mail.gmail.com>
Subject: Re: [Patch v4 03/18] KVM: x86/mmu: Track count of pages in KVM MMU
 page caches globally
To:     David Matlack <dmatlack@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 9, 2023 at 4:22=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
>
> On Mon, Mar 06, 2023 at 02:41:12PM -0800, Vipin Sharma wrote:
> >
> >  static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
> >  {
> >       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
> > -     kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> > +     mutex_lock(&vcpu->arch.mmu_shadow_page_cache_lock);
> > +     mmu_free_sp_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> > +     mutex_unlock(&vcpu->arch.mmu_shadow_page_cache_lock);
>
> Is this lock necessary (even when the shrinker is hooked up)?
> mmu_free_memory_caches() is only called when KVM fails to create a vCPU
> (before it has been added to vcpu_array) or during VM destruction (after
> the VM has been removed from vm_list).

My approach was if shrinker ran just before VM destruction and removed
pages, it would reduce nobjs variable in the cache. Now, when the VM
is being destroyed, mmu_free_sp_memory_cache() will first read the
nobjs variable to update the global counter and free the cache. To be
sure that the latest value is read and there is no memory ordering
issue I used mutex.

I discussed with Sean offline and he pointed out that x86 is strongly
ordered and mutex is not needed when freeing memory caches.
