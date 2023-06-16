Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE657323FD
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 02:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238242AbjFPAAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 20:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjFPAAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 20:00:52 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7BE2719
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 17:00:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bc501a1b17fso88963276.3
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 17:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686873651; x=1689465651;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xTMEKODPb3FRJH2K0p0YFyg3i5TgEpiZ3kirtZdTv2w=;
        b=tbF2tohEtNLhni/iXAr2HyqNmMRvOaf26O4dDG69+zW+inRRkk0Bw3jL93JHrgbLNY
         1TV+5AqWnXfAiXAtYLHtq79rKjfJ++Qai5D/nVCLLJegnYTfQt0j8O1urGlq1uF7nNEE
         qzaWUmQJUeIuD1hDg/PXU8k25x2Vc+HlQKxpk9WEpUNcsVNth60XvynygkTdRoi/4QwR
         iDfNDfrUouGx/fKx55ou+AQRxnjZWo0ll2TYl/1at+sTtbAUW4ARjjM13d13Lmlhiu02
         tJgnNTKTXxPIyZabyzOHnMdlkN2xFjNZ0UBwULzMvf2HZkWjnMyvvmDMoQOMQToV5R3O
         4ZZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686873651; x=1689465651;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xTMEKODPb3FRJH2K0p0YFyg3i5TgEpiZ3kirtZdTv2w=;
        b=VTqCo8BQfYQjqLInPhksd6+EF8pZYA+SLED0MtkTwXCXTC08gFuqZW44SIK7lPc4IA
         yDOxHoIyFrwGbjYTAz9IYf5WQK7a05piQroTblLl3lO2v98QJBOsCqkKtzrI4v6ErmGh
         HUwpptlR7bkHfg35vzToEiMK0klETVy+tAxUrbVvIgFvciYAb3Qc11PtZ4+003/HdW9l
         E3twzpxH1d23IcpYwldZhwxqNYyxoh/r2y38B/iUdwkwH8NiPzQHIR4W3EAL6hNhjgbL
         O8hyyVfWqtpXkz5VgphVCnVbmbNx+Bvjhce2f+EASqquWBWaDoAOV4jt/fHeODnjgtrH
         eUKg==
X-Gm-Message-State: AC+VfDxL/jlo3iUHP+r+0AobdoS556y8F6dmMpDYzE6jp8YQZ1TSqfDM
        rq2Z160aArKv4iB1I87WmCTeCKKMUKM=
X-Google-Smtp-Source: ACHHUZ6YLELUNWNquVJwqHsbJ/VtDfHCXjATrg+bNtW8UobZV18L1xo3A3SD3wfDA14g+Ahi5/wRw46EJVs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:420c:0:b0:bd0:4e03:a247 with SMTP id
 p12-20020a25420c000000b00bd04e03a247mr70704yba.5.1686873651284; Thu, 15 Jun
 2023 17:00:51 -0700 (PDT)
Date:   Thu, 15 Jun 2023 17:00:49 -0700
In-Reply-To: <ZIufL7p/ZvxjXwK5@google.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com> <ZIufL7p/ZvxjXwK5@google.com>
Message-ID: <ZIumMeRxDzzcKpUh@google.com>
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 15, 2023, Sean Christopherson wrote:
> Your cover letter from v2 back in April said the same thing.  Why hasn't the patch
> been posted?  And what exactly is the issue?  IIUC, setting CR4.CET with
> MSR_IA32_S_CET=0 and MSR_IA32_U_CET=0 should be a nop, which suggests that there's
> a KVM bug.  And if that's the case, the next obvious questions is, why are you
> posting known buggy code?

Ah, is the problem that the test doesn't set CR0.WP as required by CR4.CET=1?
