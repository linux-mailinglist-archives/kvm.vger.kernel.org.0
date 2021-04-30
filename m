Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D501336FE0C
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 17:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhD3PuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 11:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhD3PuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 11:50:08 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD2CC06174A
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 08:49:20 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id h36so56634603lfv.7
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 08:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N/UPUp4HGQ7DUeHHfUkqK9fCJ9kbgVk9zzLyqLqjGfM=;
        b=RNDNI9bO32iPq815h6PEKYMHm9ubqdtxdPpz0MYKrikxt/WRGVn2PCO53QFc4kl1l+
         +H/Me1WPAUS78AzlQKSe1l+mtUy2B/u2d7M8MhhlXdCch2TieSeIhp6FZIVtDX4UB2Tb
         G8wLchTSng1b1MM6SHwqCE58wBt12SAw4e+xMeOmjXpiGZlCVk7asNXwkpgH76O+6AoI
         zsCFbePd3iJmd2+wpwfwRvTabsOyjEUqHYvuOJz+g/0MCozNX8k+rIF7xexPC59WMQm/
         9VJPziljufYbwH1BhAUEhsriAUzDjMGZS2DfF3Nwjwm/jgoWWBnns37NFDaVz5FFtHNH
         3SvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N/UPUp4HGQ7DUeHHfUkqK9fCJ9kbgVk9zzLyqLqjGfM=;
        b=SchKLL2C6vxHNxkOpMQZzUryp9jqw8uIyjDy9O8018d+GiMjkCZ2udqPHgjX8OXQLr
         Q/rirOJ6H3KYk1Niy2iiydb7e2+v97ragDjjBY2P0SBWR6FXn1O55e0MB7Y2OXtNTBsm
         mIx2dil3bxxcsnukMa/CyaIFPTOC7DUeYkrnQDFeWax0pMbh840e9+Tpw31xzGZPDeLS
         egpNiMXuZzAWdU3DGg59kNlGjr9CGIQeOxrzyIkdv0nBTYlw++CnvGPEZ7TZVRnLdyyd
         JItkz5jy0rdmZK66HKW+h0YUvuR9QG+WkozHIFGBBK2uFBGxWYl45oLpd+Ze88K4rXzb
         QRfg==
X-Gm-Message-State: AOAM531OHuMovcEA9dDSmZlrzt9Z6sR6EBX5zQarRJdzuT5/fVgi/Epd
        jdUuZ1CgmzFyxRB1DPt3p1ESjU378qgOa7iy/qqkeA==
X-Google-Smtp-Source: ABdhPJyP6PCLmh4e9bLc4x603SQsBDJnGdbm4xuuVPZwgz3jH/5LEJSNs2axdGI+b3kYh732duvxzboW/5Z8cXMSEhY=
X-Received: by 2002:a19:c511:: with SMTP id w17mr3793880lfe.80.1619797758532;
 Fri, 30 Apr 2021 08:49:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210429162233.116849-1-venkateshs@chromium.org>
In-Reply-To: <20210429162233.116849-1-venkateshs@chromium.org>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 30 Apr 2021 08:48:51 -0700
Message-ID: <CALzav=ccDsmemKK2ffBKertVD2yMZUFsYEzvrwNO4BUhCRR2Qw@mail.gmail.com>
Subject: Re: [PATCH] kvm: exit halt polling on need_resched() as well
To:     Venkatesh Srinivas <venkateshs@chromium.org>
Cc:     kvm list <kvm@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Segall <bsegall@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021 at 9:22 AM Venkatesh Srinivas
<venkateshs@chromium.org> wrote:
>
> From: Benjamin Segall <bsegall@google.com>
>
> single_task_running() is usually more general than need_resched()
> but CFS_BANDWIDTH throttling will use resched_task() when there
> is just one task to get the task to block. This was causing
> long-need_resched warnings and was likely allowing VMs to
> overrun their quota when halt polling.
>
> Signed-off-by: Ben Segall <bsegall@google.com>
> Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>

Reviewed-by: David Matlack <dmatlack@google.com>
