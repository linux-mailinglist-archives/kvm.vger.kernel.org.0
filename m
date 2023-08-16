Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FC977ECB1
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 00:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346718AbjHPWCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 18:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346700AbjHPWBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 18:01:54 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAD6F2
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 15:01:53 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-68874e3d89dso354548b3a.1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 15:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692223313; x=1692828113;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VBWbG2QXVJxk1xBNtiZNPqeLW4yQOwcqBAAuTBoWz9U=;
        b=7yK6nlaM2bwfZv5iDk55eg/lYYmEMSRwr5atiJ9WsovSYfY6fGKBta1lCVV5aYmckx
         8yiK7t4Mnw7iEtfTm+A/AS/UWyV04DZ6eCMFcUlVCTukikXQ2nQReiDspIg0QLMfdeNh
         Vo+mRcwX4BB4+cwTZFtze9vU0E+AIPXkdiAa6jK0c+CSjkqfh5EhgZJqArNlxkT67s1N
         FOX1ciMZYoN69DRgFDrhaIo7CdclnhjU1gKdTZxxtN5RVk3JXGBAEo4f+yAy1mlhKWT/
         dk28REorXDFlkSUKQVLek5hAhV4UWkkuGsfDVY9gXz0+ZnZpwmJFLzSnZpP0RWB2NaPS
         1rDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692223313; x=1692828113;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VBWbG2QXVJxk1xBNtiZNPqeLW4yQOwcqBAAuTBoWz9U=;
        b=DCXfkzWQueSXAnJPWkC3OK2dfJNNyyviG77jISNB6wrwGEdnxkHfmfeT3fTFSl6PJp
         Xf5KvQ4cileuYjw2gMTEJWwi7QE/gJynzqHCQ36cM/RfTGeDHH/0ude3wUuCNiPyuAqb
         lGayqTRNJNyjJ+rwEZvnvqNSkBu1FuDGLOQdBXY7r8utE7rEy2Q91omDUelriJbyKjj+
         /dmaFI88SyPTFbf1Dp7xlFQSuoaE0k+J85kpvAzYqYuAu4tmdlI4Q4w5lm4BGuOBFKRL
         HzCG6Ar1orlPBsQgRB32h+JWEWYgZkjObbo5bF9rcMVkK90/H2FguuY2fX5ygSlDgB4n
         L5aQ==
X-Gm-Message-State: AOJu0YybZ1Nfd/5xn/CFvKdwRDPaGNcDdxFCEox2xADqbLslXkFgiAOV
        1FEUM57zuzGHov58g4877xkdhE0GlYg=
X-Google-Smtp-Source: AGHT+IECGuILJhGG7M10tme6mh4YKaUBjEHoQvuTjBLw+EFSHmvpxYXkTjIEzuG1aw08h29gjmonNn4jiJY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9a0:b0:687:5274:da17 with SMTP id
 u32-20020a056a0009a000b006875274da17mr414480pfg.2.1692223312805; Wed, 16 Aug
 2023 15:01:52 -0700 (PDT)
Date:   Wed, 16 Aug 2023 15:01:51 -0700
In-Reply-To: <20230719144131.29052-8-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230719144131.29052-1-binbin.wu@linux.intel.com> <20230719144131.29052-8-binbin.wu@linux.intel.com>
Message-ID: <ZN1HT61WM0Pmxqmr@google.com>
Subject: Re: [PATCH v10 7/9] KVM: VMX: Implement and wire get_untagged_addr()
 for LAM
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023, Binbin Wu wrote:
> +	return (sign_extend64(gva, lam_bit) & ~BIT_ULL(63)) | (gva & BIT_ULL(63));

Almost forgot.  Please add a comment explaning how LAM untags the address,
specifically the whole bit 63 preservation.  The logic is actually straightforward,
but the above looks way more complex than it actually is.  This?

	/*
	 * Untag the address by sign-extending the LAM bit, but NOT to bit 63.
	 * Bit 63 is retained from the raw virtual address so that untagging
	 * doesn't change a user access to a supervisor access, and vice versa.
	 */
