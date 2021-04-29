Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E048C36EE46
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 18:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbhD2Qkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 12:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbhD2Qke (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 12:40:34 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D243C06138B
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 09:39:47 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id n32-20020a9d1ea30000b02902a53d6ad4bdso6908351otn.3
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 09:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ixwoeHd50m6yi5/B4CIkxSJFBB/BaPT5DwpNhFLHMuQ=;
        b=BDxNH2RuCXa/E45AdxHwAozvJYEphArYc+zMAXpSPoswyFmNzdPZsvb72VDJ8KmNaR
         QhJ/w62JOUrQWq5hmMwENhHbr0nkM5IEMpPkrVjlmD9Ig3YvSKgGcQKudlrDhBjSTHFp
         C0WGHXpizXI2C3LbvCUUNl5kXT1hqsoYcB2tUw+nVmd7hNi0y7xK26IQW0Mz8Vhqa7dN
         7Vxh0tx606cU492BKbjbN60fS8Ocfyabj10tbCwHbJF559moIhPnaGohGrOURmN5BpBo
         GLMqf6xtPtremSCjlhXV9kTs7kimBr8PaxWhcvSYEVIHHIZFUTS+myGpGxqcKqPZoIp4
         hgUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ixwoeHd50m6yi5/B4CIkxSJFBB/BaPT5DwpNhFLHMuQ=;
        b=TzJvsr52GzC9kYT5H6uDwXtTg6lq4kLMhXpiyXp9EaVRrpakKRds3WQ28li1rgf5bP
         5zmxgOPlswitYOCiQwfEH1bbTYTnDV0FYR4JXINdHYQmXarBPwf32c7R7zeeWgGTpMpi
         7o7ylE4ovcHqPI1btOnligbVXEw8Av341Tuml2LhQ4Wpav279WiNSuwy8yftaTk+YEto
         BMT/4LGi5g/3a3eSuhA04TWjDFFJ0H2sN8RC1gf8lbHAOwQMOVPnhKykl7WKBZqgijDE
         E6buBsdAjLdOYBjf1Q/MHc5c2puJiZW1PvJPs9POyTY3GkS5vEQYNtFuIPDf9ks0HKuA
         ZLHw==
X-Gm-Message-State: AOAM531RNrLaWxgSDQOuqkx05bdlf6b9CTe+IwpdqlCXFA+95gtMio1F
        YJfRCQw4rfttH6SmmYPCf08PHU9V6S9XWlc2yGxnUPUeHLA=
X-Google-Smtp-Source: ABdhPJxtndknXjuzfV43itjqUPlRlj7ljqUbZu/4UIaI8w2JkAq/zyJn9vLJv76Z2BJjo1RI1DWRmRdJZ+QV40j3jxo=
X-Received: by 2002:a05:6830:4009:: with SMTP id h9mr2721861ots.295.1619714386733;
 Thu, 29 Apr 2021 09:39:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210429162233.116849-1-venkateshs@chromium.org>
In-Reply-To: <20210429162233.116849-1-venkateshs@chromium.org>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 29 Apr 2021 09:39:35 -0700
Message-ID: <CALMp9eQXj7aN2=rE50Yyt5z-Pf5wfO1w5k9rf1Q+LBnpN3zx5A@mail.gmail.com>
Subject: Re: [PATCH] kvm: exit halt polling on need_resched() as well
To:     Venkatesh Srinivas <venkateshs@chromium.org>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
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
Reviewed-by: Jim Mattson <jmattson@google.com>
