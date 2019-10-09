Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35758D0EE7
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 14:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730979AbfJIMeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 08:34:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730244AbfJIMeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 08:34:22 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7E0483CBE2
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 12:34:22 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id p6so442846wmc.3
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 05:34:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NU17Yq/AK4USZPcdc43DTuLWNe9T5lZq4o05Tuv7xGk=;
        b=KayuKQEob2N9twEwsuwf1MzJDDba8/goX/X9p1uq1WxcatX7wT3OYHwe33W2Ceu5eB
         4djul0Z/+yhI7ENT1I6TJtnCypGU0oXa0oUfLRVtXS5mQ+iac+UaUHWeI817IdwuwhLC
         +7wTfvCQu4E83zNobSLA4wIYUA0sA1jrT1VWrFjLZ7mVdwe96pl9pQ4ZGrculLB0Ep7k
         c2krrMb3seizriPc+MwIDG2EnOxPqQS8/czwuV8uF6fRb8a3cr/PZYwdVqoRO7m9gGkG
         zPnfeYSrBUD2QAV1d+PFApWBwoF/xoKFlcXYfeu1xZFVl9AQJYwpCDVg856oeCGcrX0x
         OBFg==
X-Gm-Message-State: APjAAAW1YIHxd4z56q2grsrenNWRWfPYLUxfgIHLILBv9mawdxeQf5Dw
        aKT3KvAHBcyn46DfOacSakcgI48T5JI1rp8w7oV/SCWzoguDCYY07s6Ac2yqPjrwR7ugAI7OFUf
        Ta8m+WkMgf0v/
X-Received: by 2002:a05:6000:d:: with SMTP id h13mr2901724wrx.346.1570624460998;
        Wed, 09 Oct 2019 05:34:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz4krLMd42RXMqGzfozS0sdlYRgeYvbnnDan0LJVeGhK6peLuktJv7VzxKNfuT+j3QL6TMzEA==
X-Received: by 2002:a05:6000:d:: with SMTP id h13mr2901711wrx.346.1570624460804;
        Wed, 09 Oct 2019 05:34:20 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id u7sm3181752wrp.19.2019.10.09.05.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 05:34:20 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Subject: Re: [Patch 2/6] KVM: VMX: Use wrmsr for switching between guest and host IA32_XSS
In-Reply-To: <fcec86ca-a9d2-2204-d92d-8f1e21c4a226@redhat.com>
References: <20191009004142.225377-1-aaronlewis@google.com> <20191009004142.225377-2-aaronlewis@google.com> <fcec86ca-a9d2-2204-d92d-8f1e21c4a226@redhat.com>
Date:   Wed, 09 Oct 2019 14:34:19 +0200
Message-ID: <871rvmyu5w.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 09/10/19 02:41, Aaron Lewis wrote:
>> Set IA32_XSS for the guest and host during VM Enter and VM Exit
>> transitions rather than by using the MSR-load areas.
>> 
>> Reviewed-by: Jim Mattson <jmattson@google.com>
>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>
> This commit message is missing an explanation of why this is a good thing.
>
> Also, the series is missing a cover letter that explains a bit more of
> the overall picture.  I have no problem with no cover letter for
> two-patch series, but at six it is definitely a requirement.
>
> So I'm replying to this patch as a proxy for the whole series, and
> asking: why is it useful to enable XSAVES (on AMD or anywhere) if anyway
> IA32_XSS is limited to zero?

I know at least one good reason to do so: Hyper-V 2016 Gen1 (but not
Gen2!) doesn't seem to be able to boot without XSAVES (don't ask me
why). I'm not particularly sure if Aaron is aiming at fixing this one
though.

-- 
Vitaly
