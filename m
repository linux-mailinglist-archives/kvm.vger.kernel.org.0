Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E89B6C3FBD
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 02:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjCVB3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 21:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjCVB3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 21:29:41 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BB7360BE
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:29:41 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-17671fb717cso18075481fac.8
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679448580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NSCyyhzST23ex5r5AgFi+RlkaLf2K1PVz0O5N4A+Lbw=;
        b=jzf02hDKsUrLyp3O5LE12aIO7p14qRl7n6B5pP2Vba01AI84MTd/duAFs38nhOlpy2
         b6gKkomiMXft8nEsnwtW2nOXrXcs7CGM5h7d3V/vi3QYX8M1O28gNcsLeU2geT//PJb/
         J3TwOhGyBvDPf+fgQl/2gKMJ73lNZAozmCOQBz9CXiQ+7eMIgDYK1UjpN2Skq84pCZMh
         abD0ZeX+2thleQLRjVKr3gS5TpqEqKiuoHDlW/hTNS2ikvS/4LHElynzDKBlrjuW65iO
         FRemaTLVSwXVN3utHWpPvCSVGv2xK/XWbm1AiyEBI8bHOqxGq0cS8BVXqOL9QvKIBFzJ
         uD+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679448580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NSCyyhzST23ex5r5AgFi+RlkaLf2K1PVz0O5N4A+Lbw=;
        b=DLT8/gtRlzGhMLW5LyarGO5LJ/1yqNwg/e2+MoW4VkQR+A4aafawkxoh+ycqx5T/cY
         D12tcK1dVcBq22s2yMIbPkGCT6fbvfkXDDdwqCm4Ys8oTcCmix3P6vDnWYv9CDLi5gKX
         bflbVGGpKcEcvfXKAa2eMsmytdV3oK/kBGu0Ke8+2dh6DXImLxx5nhtYu9+RyFxczWIp
         UTcd9sJdVAO7KySEMKPnDN7xBtg4S4dY2XXmUpAKedYt8Y294jzLtJPpN3/BFNgdTm5j
         gZ2vxxhpCNvVxlPQxNIfp/zNSEDF6Uy6ZEJk8G1iLNnW/I6dyyH6XQd/wOpBm3YRpFNw
         uoaQ==
X-Gm-Message-State: AO0yUKUxC2oLz7ppbAZwymLkw4+rAMUMBYpWBHo5zqvDgiYfHNJ0UAIg
        mMhsRTCt7v9bWLpgezd5mIvTSKeuCycj7XzaHSP1MYb3OYE5VjPVCS8=
X-Google-Smtp-Source: AK7set/ysncTXzUcWP1joJZ3auqDbvvUbIdr0nTvGVzzXRrd9cUIMlK/G+vacoJa+sl7uH4lMvdqANYtbw21s3MGGJI=
X-Received: by 2002:a05:6870:df97:b0:17b:f094:5478 with SMTP id
 us23-20020a056870df9700b0017bf0945478mr390201oab.2.1679448580241; Tue, 21 Mar
 2023 18:29:40 -0700 (PDT)
MIME-Version: 1.0
References: <ZBl4592947wC7WKI@suse.de> <66eee693371c11bbd2173ad5d91afc740aa17b46.camel@linux.ibm.com>
 <ZBmmjlNdBwVju6ib@suse.de> <c2e8af835723c453adaba4b66db533a158076bbf.camel@linux.ibm.com>
 <ZBnJ6ZCuQJTVMM8h@suse.de> <7d615af4c6a9e5eeb0337d98c9e9ddca6d2cbdef.camel@linux.ibm.com>
In-Reply-To: <7d615af4c6a9e5eeb0337d98c9e9ddca6d2cbdef.camel@linux.ibm.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 21 Mar 2023 18:29:29 -0700
Message-ID: <CAA03e5F=Giy5pWbcc9M+O+=FTqL0rrCWSzcgr8V2s-xqjpxKJA@mail.gmail.com>
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
To:     jejb@linux.ibm.com
Cc:     =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <jroedel@suse.de>,
        amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 1:05=E2=80=AFPM James Bottomley <jejb@linux.ibm.com=
> wrote:
>
> > Of course we could start changing linux-svsm to support the same
> > goals, but I think the end result will not be very different from
> > what COCONUT looks now.
>
> That's entirely possible, so what are the chances of combining the
> projects now so we don't get a split in community effort?

Very cool to see this announcement and read the discussion!

One SVSM will be better for Google too. Specifically:
- One hypervisor/SVSM startup sequence is easier for us to get working
- One SVSM is easier to test/qualify/deploy
- Generally speaking, things will be easier for us if all SNP VMs
start running off of the same "first mutable code". I.e., the same
SVSM, UEFI, etc.
