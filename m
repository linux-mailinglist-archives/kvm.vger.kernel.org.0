Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FA36DB3B4
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 20:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbjDGS4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 14:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbjDGSz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 14:55:59 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9E811668
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 11:54:00 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id p5-20020a17090a428500b002400d8a8d1dso982017pjg.7
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 11:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680893583;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JtD7uYu2AEB4EAkFkUforKfqJVRaVzuspxc1DuzMG0k=;
        b=l3bMqfhQinI7PNB+kkP/WfLCVnDF6MQJqRcsrfpSpWOShDcKzBcPiSDye3A0RAl0he
         a0MpAcZ5RX8Qg/eJQ8copDiYIT/RdtsOkKLJNGlUK641X/QxLwlwnQe/1shfM8KK+TS5
         1uzeEfDkrpfiaVXKaqW5/7nkisjqy1s1yqoZeuuFUwwO+4yVPKkkK7C3mAz79X4rBJwy
         J5VnmIX0nZ2Uie0rUAWnYAjDQJkvARwnLRdRqlv/kagUNslWhHxfXSeNXqbzTh6m5cBv
         /4s7mkuIBuq94gaW4tnhOIpCj0L+tMJSNKWD+6bPvpin256+1Q8yuIglxX1Mf4WDx2QL
         5E7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680893583;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JtD7uYu2AEB4EAkFkUforKfqJVRaVzuspxc1DuzMG0k=;
        b=RpOv3aJAv7Y1pHMeoqGXdKYDMEf25cvQ3xoJJOfN38gHD30JvKXcCEpu6FV/aGbGic
         MjCqKJRoFmdn11mzsi29Mi1LiePw6GC+TjIqG521vVbODdWX3ZoICDKnLboZcf5AAZb9
         CPyCLr7s0dbM4R28slwsDAnh9xZ0NqADooVovCAJ53+5NLl5qydV7a4Kgq9ROnFOk2JV
         T+GarptryYmhVnyrPQIW0du2ZCKlHStzBVix1onRVf5MAbj2Y+7uHYj9J8G1ieGebkgn
         DJud6/jKIbBuJMXXQEJf1DDklzMsdMGNsoEqn6ZDastNJvCzocAPNf7L0ebF1ax4gxRE
         RQsg==
X-Gm-Message-State: AAQBX9dzfyDIWoqlc8iqFTyXfP6mwFKACXzoNwjxqNj3kDknYtJOg/5c
        LwDKfCCCa1aCgxYC7G43DquJ0T1dYaM=
X-Google-Smtp-Source: AKy350Y2Yngcln89pqTWLqyNfUFtYV+3C6KELj7jFHVD0I++M40X4kH2+VAe1TQK8CpqNWKcKQU/sJJCtjU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2cb:b0:1a2:401f:6dae with SMTP id
 n11-20020a170902d2cb00b001a2401f6daemr1136375plc.4.1680893583664; Fri, 07 Apr
 2023 11:53:03 -0700 (PDT)
Date:   Fri, 7 Apr 2023 11:53:02 -0700
In-Reply-To: <20230307141400.1486314-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230307141400.1486314-1-aaronlewis@google.com> <20230307141400.1486314-5-aaronlewis@google.com>
Message-ID: <ZDBmjt0+nFkZkoG6@google.com>
Subject: Re: [PATCH v3 4/5] KVM: selftests: Fixup test asserts
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        like.xu.linux@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Same shortlog problem.

On Tue, Mar 07, 2023, Aaron Lewis wrote:
> Fix up both ASSERT_PMC_COUNTING and ASSERT_PMC_NOT_COUNTING in the
> pmu_event_filter_test by adding additional context in the assert
> message.

I 100% agree that the asserts are flawed, but in the context of changelogs, "fix"
almost always implies something is broken.  In this case, what is being asserted
is completely ok, it's only the messages that are bad.

Easiest thing is to just describe the change and explain why it's desirable, and
dodge the question of whether or not this should be considered a fix.

    Provide the actual vs. expected count in the PMU event filter test's
    asserts instead of relying on pr_info() to provide the context, e.g. so
    that all information needed to triage a failure is readily available even
    if the environment in which the test is run captures only the assert
    itself.
