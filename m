Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2806B32C5
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 01:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjCJA2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 19:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjCJA2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 19:28:48 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70136F2490
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 16:28:47 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-536af432ee5so68296047b3.0
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 16:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678408126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qF04VPgueh2SKaxQTFBfaR6wxxhC9lXU3sZE07syoaw=;
        b=X3aHcVPsPrl6qNUh8U2pEh3DTck3BpDkmOKKBD7vl0sz6Nu734G6K7QOCJ6VITu+OC
         RHxnhEz3BlrDa+jOzy7Xwea1rID4KIvlAnYZb+kydHFZEnC4h1NmBIPku1Q1ZT8dyM6h
         27/bq0R6+0gT3dhZ4rONl9p1mbx0reGbZFfPa32lTc0/1l+4lQBQKbn+Cvv00pT0tVjy
         YHB/jbFdKgU+pjLPCO8QIVWumtvoROZlurXuHiCnv8hAJ2hR6gVC19qqkOc2WmD8Eu3G
         MCkFAWtbAtScxsNMaqDutzFqSqlUy75IMqW9Oz7kSgIE1xz0tnL2TtA0vGvf0W3fp847
         r7Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678408126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qF04VPgueh2SKaxQTFBfaR6wxxhC9lXU3sZE07syoaw=;
        b=p/n+RAXP6Vd3gjMfbK+wQY01EagTK9e8/01c983InXWmH7aZRUndj4V6fzkWhYYVKc
         7JdE/4v/Mpq6kSqXV1bUaJ29hQ7YTiqzAC5jBTzbT86NtHhYn97BwMnPvZ++QWiD0Fob
         hPGEGoAM5/pWPzAA4X1dR5iX3gmm356GwarL89/mPfUc5Qxwp6aUhDKiravneCJfftJs
         XI5lhLTwaMu1DiJ1LYs1oIhrJszPsX++hLrlOSlJQUtGvkJS3CKU6XYtufmHuQ9/Anie
         q4mzPxC/6iAtfTGIgtVnaREPnIM1ZSlYS6qkoRHy9dJZJ7tSx99nQcLaDHqQHf8D+cKs
         LmcA==
X-Gm-Message-State: AO0yUKX27ZyefQBNzLxa+AAbPJvFuRhSnGj3rQATnv09A8QDcgv2XsQ+
        VfxQZ1QT/xJvfHRMEFOoePLyM3vEzFHczAKvPKBuig==
X-Google-Smtp-Source: AK7set+g99RJ9xbUn+LPvdxkpcJsaqN4LP1rQPmQKWucbbV4hxwHZ6toxcBx4ohxx0rJfG6pEt81IuQjqcSHjJ1XtuI=
X-Received: by 2002:a81:ad24:0:b0:52e:bb2d:2841 with SMTP id
 l36-20020a81ad24000000b0052ebb2d2841mr14718152ywh.10.1678408126408; Thu, 09
 Mar 2023 16:28:46 -0800 (PST)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-4-vipinsh@google.com>
 <ZApxh/GYfqev7sHA@google.com>
In-Reply-To: <ZApxh/GYfqev7sHA@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 9 Mar 2023 16:28:10 -0800
Message-ID: <CAHVum0eQzmLXDxMy3+LpmGxVU7YsT1wRNYkFq9o7sfR2uNK-xA@mail.gmail.com>
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

On Thu, Mar 9, 2023 at 3:53=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
>
> On Mon, Mar 06, 2023 at 02:41:12PM -0800, Vipin Sharma wrote:
> > Create a global counter for total number of pages available
> > in MMU page caches across all VMs. Add mmu_shadow_page_cache
> > pages to this counter.
>
> I think I prefer counting the objects on-demand in mmu_shrink_count(),
> instead of keeping track of the count. Keeping track of the count adds
> complexity to the topup/alloc paths for the sole benefit of the
> shrinker. I'd rather contain that complexity to the shrinker code unless
> there is a compelling reason to optimize mmu_shrink_count().
>
> IIRC we discussed this at one point. Was there a reason to take this
> approach that I'm just forgetting?

To count on demand, we first need to lock on kvm_lock and then for
each VMs iterate through each vCPU, take a lock, and sum the objects
count in caches. When the NUMA support will be introduced in this
series then it means we have to iterate even more caches. We
can't/shouldn't use mutex_trylock() as it will not give the correct
picture and when shrink_scan is called count can be totally different.

scan_count() API comment says to not do any deadlock check (I don't
know what does that mean) and percpu_counter is very fast when we are
adding/subtracting pages so the effect of using it to keep global
count is very minimal. Since, there is not much impact to using
percpu_count compared to previous one, we ended our discussion with
keeping this per cpu counter.
