Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD44368701A
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 21:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjBAUrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 15:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbjBAUrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 15:47:31 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7337CC8E
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 12:46:01 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id q19so67024edd.2
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 12:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qi/CEnKwOsWvZyQG3j5nugYoM+i4R+Edn8Y4YOIOMEc=;
        b=a7ehvPKTQB+cAS+tXX2WGokeoGiUy7y9+q8Npe+czuVuXF3Hs44SC/Q2Zl51p5h3HU
         gDBBXaTKcH61VPvJHvgcEYjNEpmSFRlHXT2f+XfsL/zA69xTHQzHr0s7Cp/PltLScbIn
         v8PeiJDsqeRFalVM4rTq5FSN0x0RziSpjl5nbNp7cOJMkupr+nJHWq8NGhQR4IJG6f2h
         rVgaA+TJBHM3Myg1iAlihcvOvgT1/D/95G86wChVh9bIqo37MKMh/GKHU6paSOZqx5ts
         JK7fEEAOjyZWNU1KDAz65vqefm7eB/TiLReDhsYnPyjqHTXpsxGnjJG2Id7jO1u0cd2z
         6zpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qi/CEnKwOsWvZyQG3j5nugYoM+i4R+Edn8Y4YOIOMEc=;
        b=aPWYVcuMWmVYodVL0VUAgViqyzz4oH1F2mrAhTWTO66OTI8+C2UneC8lGX5QP1oE2y
         CamXCirixR+DNe2gYdZHGuy2pu/WkIL8lGTOQHZlZAzlg+Y16JLSu2AtgXG6LJMSF5Ca
         Rgc9tluKaHyVC/Dk1OwSNpMO9PQ44+g8WWB0pyhsLZ5TH7Vyzd/EawK9rq6zGvPj24Uk
         8eURAjxl52BTpoQ56dhPe59fKqlTbTWEbx0AyV93+k0udcUjQnH+CHYDhNWwMXXNZWTH
         afQLgoroToPlcgMWovSEjoLlRs3CYGodj9sR8b5madatB8TtGCAO++kWFDW7QXvMfIuW
         19KQ==
X-Gm-Message-State: AO0yUKUcqoxweHaLAc6N35PksJD5x1X91VMUqPoUAlmeSS8dsqadtst8
        PwhqZGQinD3JFCbhk+ggfELGOctJTEjVpR6J65zfgbomTeWdacft
X-Google-Smtp-Source: AK7set/ZkUlZqpiWXnrr5+yAKOVVZjKeEoN06C9cQhxoC/aYjNJVzGbgRYXRJz+ugljzyrzu8Il9l9RxF9DxwX+aYR8=
X-Received: by 2002:a50:f60f:0:b0:4a2:27c2:aa9a with SMTP id
 c15-20020a50f60f000000b004a227c2aa9amr1111124edn.61.1675284355605; Wed, 01
 Feb 2023 12:45:55 -0800 (PST)
MIME-Version: 1.0
References: <20221221222418.3307832-1-bgardon@google.com> <Y9rFWP7b/j25IjtZ@google.com>
In-Reply-To: <Y9rFWP7b/j25IjtZ@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 1 Feb 2023 12:45:44 -0800
Message-ID: <CANgfPd-r2syiUNxiw_H9HXRAuCavGw+EYYqfkj=L8Dfn-sMtSA@mail.gmail.com>
Subject: Re: [RFC 00/14] KVM: x86/MMU: Formalize the Shadow MMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Nagareddy Reddy <nspreddy@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Feb 1, 2023 at 12:02 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Dec 21, 2022, Ben Gardon wrote:
> > This series builds on 9352e7470a1b4edd2fa9d235420ecc7bc3971bdc.
>
> Before you send the next version, can you tweak your workflow to generate the
> base commit via `git format-patch --base`?  That makes it much easier for humans
> and scripts to find the base commit, and saves you from having to remember to
> manually specify the base.  Because of the code movement, applying this series
> without the precise base is an exercise in frustration.
>
> E.g. my workflow does
>
>         git format-patch --base=HEAD~$nr <more crud>
>
> where $nr is the number of patches to generate.  There's also an "auto" option,
> but IIRC that only works if you have the upstream pointing at the base, e.g. it
> falls apart if upstream points at your own remote "backup" repo.

Sure thing, thanks for the tip!
