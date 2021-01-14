Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B782F5E32
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 11:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbhANJ7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 04:59:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47488 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726858AbhANJ7N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 04:59:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610618268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bVl5rOU+HrnFitoJh1CZVmjqhbF76mPBERzkT+db+eg=;
        b=N7N68pkrhClqNG77X4V1P6JkLHRwNGBD0tdXr1N9ljqM3IXg+Y+ZEshT5X7T9tu+sM5Apl
        Xu2rN7ClPqVW7FNdIs7xwLCLpvrk+WyHam6/DKVrNwXLUFntv14HuYtJLWXuZWkykseB+Q
        L3+00ESKmb3WzssqioRBNBgbOfYb+ec=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-kHdkw4xoNPOb6o2ftpJytw-1; Thu, 14 Jan 2021 04:57:46 -0500
X-MC-Unique: kHdkw4xoNPOb6o2ftpJytw-1
Received: by mail-ed1-f72.google.com with SMTP id x13so2188873edi.7
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 01:57:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=bVl5rOU+HrnFitoJh1CZVmjqhbF76mPBERzkT+db+eg=;
        b=MivZq6oWD87g7nzfouMD6+8DG4fXP3uoRvF6g5rHhpF0CKHi8ckvtM5Z1Qf8CYsiP7
         YMgqDg3U8s1ykAfdA6ptNTJDztF/jqf+LuCurSYPRcm0MR6EUP9NnuNaTSuE6Ij545Qi
         gogMFOsfR7aB9x4fphEqr3nVSQ1KKS4YXQbBf3lCLIVRsn5hpSlC48Z1c0y12RX5MVZ1
         JZEFbXmbs66jaGWkGvC9a9oEaxBybfbdowCUX0IS0HnoKT4rgzTIr+1as5lH5hNH5JSH
         BDaeziKm2/OLyR5COopdq8Iww2Jh2I6En1x1W4b+VBDbhWZhyfwORYZ8L6B8Y0EUXSyg
         ycSA==
X-Gm-Message-State: AOAM530U99ZbxvJtRFyDKlT3++X/Qfy6MXmjQQYgFuo0sGO+BzfgOWVy
        kmrBEiIBEQK/knYEVZMyNIDHHo5JBrbYqWf4M0DT++lS+BISqH/Ng3eNKCzxJVWo7kv6iG1Kkh3
        n9y10RGRv2863
X-Received: by 2002:a17:906:13da:: with SMTP id g26mr4603909ejc.285.1610618265431;
        Thu, 14 Jan 2021 01:57:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNXN6RszazPqP4XbGtwo9cKyptdXFcfTwvzeumtC/0//AypLHdwmbOzlCcz0HUzLpqpgIjUA==
X-Received: by 2002:a17:906:13da:: with SMTP id g26mr4603901ejc.285.1610618265292;
        Thu, 14 Jan 2021 01:57:45 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m5sm1770704eja.11.2021.01.14.01.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 01:57:44 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 6/7] KVM: x86: hyper-v: Make Hyper-V emulation
 enablement conditional
In-Reply-To: <X/9c9PuAd4XJM4IR@google.com>
References: <20210113143721.328594-1-vkuznets@redhat.com>
 <20210113143721.328594-7-vkuznets@redhat.com>
 <X/9c9PuAd4XJM4IR@google.com>
Date:   Thu, 14 Jan 2021 10:57:43 +0100
Message-ID: <87v9bz7sdk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Jan 13, 2021, Vitaly Kuznetsov wrote:
>> Hyper-V emulation is enabled in KVM unconditionally. This is bad at least
>> from security standpoint as it is an extra attack surface. Ideally, there
>> should be a per-VM capability explicitly enabled by VMM but currently it
>
> Would adding a module param buy us anything (other than complexity)?
>

A tiny bit, yes. This series is aimed at protecting KVM from 'curious
guests' which can try to enable Hyper-V emulation features even when
they don't show up in CPUID. A module parameter would help to protect
against a malicious VMM which can still enable all these features. What
I'm not sure about is how common Linux-guests-only deployments (where
the parameter can actually get used) are as we'll have to keep it
'enabled' by default to avoid breaking existing deployments.

-- 
Vitaly

