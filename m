Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6D8444AFA
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 00:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhKCXCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 19:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhKCXCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 19:02:55 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B78C061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 16:00:18 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id v20so4050869plo.7
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 16:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QvH8jVpduU9Ry8vHYgUc5mc6i8LMFY8Z87vcMeWdv8s=;
        b=HpGzsg0GWVHuIoEHpWXx21vyHLVCbLc88ZJKIywK1fGEW8JOlRQLGHpq6GryiL6Blx
         QZ+zLIGdMxxNXPwH2w/NsjQjr/9g3MKIsXKJpVbhStsDyaj19uIhFr6fhwHr8W9aXvte
         ChkWgjmHrJ7lRArSuE8WHmFv3qJjBeyOl1zPmi18qS6Fg0MUIjk2Y3BjDwqPI6svOz+1
         Cs8S+5AKkKPi/I3c4HzIQnD+DxTqFsStS2qt7pZ3L7Qao/D1w87J3Z4j1b1xvTJj7iEx
         Lt1qR7SqK2tiqxMqQbLOeiMhSojvH4bXaXqKh+EopnRiu2kAFR561R//AtSM2z7AjM3c
         v/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QvH8jVpduU9Ry8vHYgUc5mc6i8LMFY8Z87vcMeWdv8s=;
        b=dqoC14rg5JdufLa3GG+eug2t1w32G9/XoZ22W1jLxTo8zH8s8Oa4e/pe+mg5XQNYZT
         NzF/IEXDzqrshlKfgQHybpoNKG1+yzMnNalJZ8oIAk3gDbmXKy4/JqBj8gAgwYevo6P4
         yPPVIdW+U8Y4qWFLANQiF2yZaNemrMo+WN47SFSinIGpauTWxNJLXhh/irHzuTmt7p4g
         7UoXBUW2E+Gsgz/lidpLi+QOcb3MDbUvmLNlfnccpocmYVQAJn15cVa8h/PJeL1MdDkG
         9SEBQsCbZtNyt8vNAQ5GKlxAxayHzyQhig5it2HCD5MsM1BUEjO2tt0V+FbH+ddwpwMn
         8ZjA==
X-Gm-Message-State: AOAM533Cc+X743zxhEJHThIQ/5f+6iLinEPpumP2EA/+PvX6YceRZje4
        sXs4IKPp4h0ukeEO0kemd65x/A30Lro/7w==
X-Google-Smtp-Source: ABdhPJw0q1ZXVogS7b+RYqM10dtu6xUCKqz0xNrOZcPtDHZjAQoVR4jb+6yXX2IgPe7UBuzpBa3FjA==
X-Received: by 2002:a17:90b:3ec6:: with SMTP id rm6mr14073297pjb.41.1635980417597;
        Wed, 03 Nov 2021 16:00:17 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p2sm397906pgb.1.2021.11.03.16.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 16:00:17 -0700 (PDT)
Date:   Wed, 3 Nov 2021 23:00:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: VMX: Add a wrapper to read index of GPR for
 INVPCID, INVVPID, and INVEPT
Message-ID: <YYMUfbKJYTFgyyD+@google.com>
References: <20211103183232.1213761-1-vipinsh@google.com>
 <20211103183232.1213761-2-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103183232.1213761-2-vipinsh@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 03, 2021, Vipin Sharma wrote:
> handle_invept(), handle_invvpid(), handle_invpcid() read the same reg2

"same reg2" doesn't provide any context as to what "reg2" is, or what it's used
for.

> on VM exit. Move them to a common wrapper function.

"Move them to a common helper function" reads as if the patch is moving the
whole handle_*() code :-)

handle_invept(), handle_invvpid(), handle_invpcid() read the same reg2
field in vmcs.VMX_INSTRUCTION_INFO to get the index of the GPR that holds
the invalidation type.  Add a helper to retrieve reg2 from VMX instr info
to consolidate and document the shift+mask magic.

> Signed-off-by: Vipin Sharma <vipinsh@google.com>

Changelog nits aside,

Reviewed-by: Sean Christopherson <seanjc@google.com> 
