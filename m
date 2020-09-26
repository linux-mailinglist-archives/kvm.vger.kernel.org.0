Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1F7279575
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 02:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729672AbgIZAPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 20:15:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44681 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729096AbgIZAPE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 20:15:04 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601079303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DMsu9Cf7UyAelokyn8g8ZGbGX3wAMlHQf3WPi/7a2fw=;
        b=atKI8RunUgxjP0Om8IkKHMY/CuIrn8vr2GYUuckNp0Yaixwgai0xvRGbdopY6YuKo3TUQq
        gplQKCJl7MaQMziRQX7AUfJpZveKUTl1/8scob0jEy6a5rYodn4rSgq5Dju1jNG4Zqrgj6
        CWp0NuJEVVLRGlNzBjcueuvhQIBZGUU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-jDu0oXiQOzy-A2_1eciCtQ-1; Fri, 25 Sep 2020 20:15:01 -0400
X-MC-Unique: jDu0oXiQOzy-A2_1eciCtQ-1
Received: by mail-wm1-f69.google.com with SMTP id r10so232273wmh.0
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 17:15:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DMsu9Cf7UyAelokyn8g8ZGbGX3wAMlHQf3WPi/7a2fw=;
        b=EhsnPBBqG1lwRwFBYG2xzakrPCoiognQd3K7j/uLOvxwnBT94tHEL7o2Xr3PEiAu2i
         LLv+Ayndx8wPLFuj8Nh36hjLWoBY0GMsVqHkmtK9qc3QTB+YYOd61O8vDLrAZbu7uVIQ
         JG9wdkA5BlP5DqCOJM2FqBcp6VqNaQA8LyBeVlEHJPcHqMfycKeIoe3x7Iu/w4DFOHLI
         CvVYvYDaEsWH0dVUuvCV/ZUgLnlDctQzmu3CXjQFu0P5iYFg5UI5jgX380cvWt/uCPQU
         qFuarCzKNpo5KyCGjD+ypdgRn79lULIqvNC8bcPdVF10f7Xue77kB2kwrNMVGdcELzF8
         lLfQ==
X-Gm-Message-State: AOAM5327+Iwph7kHby3qM3X7kEPLQ8O1CSeV+WU5DEp6Zp3vTJcvbntg
        8L/8Sgqmhmx9RrHpdLINZJNTRrAoxS4FqDdDiuiZ4XB1X6QiPjlwd1NOxd26B9ioXPWZkZGc7f6
        t2YB5ohc2hSX0
X-Received: by 2002:adf:9c93:: with SMTP id d19mr7025294wre.275.1601079300097;
        Fri, 25 Sep 2020 17:15:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxm1wiUlEdC2g5dhJZLl41obJmPj5jTOu28bJLiTneBSvhZddgQf2aWWPtCvm+OThg8ei5WMg==
X-Received: by 2002:adf:9c93:: with SMTP id d19mr7025279wre.275.1601079299851;
        Fri, 25 Sep 2020 17:14:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id v9sm5041404wrv.35.2020.09.25.17.14.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 17:14:59 -0700 (PDT)
Subject: Re: [PATCH 07/22] kvm: mmu: Support zapping SPTEs in the TDP MMU
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-8-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4fd0ef13-77bd-ed84-684a-be364a62f8fa@redhat.com>
Date:   Sat, 26 Sep 2020 02:14:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925212302.3979661-8-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 23:22, Ben Gardon wrote:
> +/*
> + * If the MMU lock is contended or this thread needs to yield, flushes
> + * the TLBs, releases, the MMU lock, yields, reacquires the MMU lock,
> + * restarts the tdp_iter's walk from the root, and returns true.
> + * If no yield is needed, returns false.
> + */

The comment is not really necessary. :)

Paolo

> +static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
> +{
> +	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
> +		kvm_flush_remote_tlbs(kvm);
> +		cond_resched_lock(&kvm->mmu_lock);
> +		tdp_iter_refresh_walk(iter);
> +		return true;
> +	} else {
> +		return false;
> +	}

