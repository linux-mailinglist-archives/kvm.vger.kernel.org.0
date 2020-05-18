Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259A61D803E
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 19:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgERRhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 13:37:14 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23840 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728376AbgERRhO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 13:37:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589823433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pW1EBLelNH4xkOAfewry7ROyh0LG2QQK4g8hD3z33Eg=;
        b=KDvmkEp/qCnxBfFjYFSKEORJ+zXqEyOcqU3TXyEZcd9DCCk95Zuw1iLHbAVqzaJubZM6vP
        qep8yhdgJ5asqbRibveqLmiVPL+NAyVvpTpuloSUfeWHNILwp7D34thtTNYdil4J0yX59F
        RaWDrcXbgAjxFqtX8wzqNwAs6liJTSE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243--BwwobJ5OyO6VlkBEbIwhg-1; Mon, 18 May 2020 13:37:11 -0400
X-MC-Unique: -BwwobJ5OyO6VlkBEbIwhg-1
Received: by mail-wr1-f70.google.com with SMTP id z10so6000613wrs.2
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 10:37:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pW1EBLelNH4xkOAfewry7ROyh0LG2QQK4g8hD3z33Eg=;
        b=ouwRGrVspBKPtHqp17hytoWe+gVpLwxCsCgKRafw77Ff78LwNyM+B4VgpCtgppE9l+
         p83JZQIYjDIsmadkvAoEE07JI5Q++B13IXphQx/md19rLMLzwRtfZtd3RsrJbhQ5Tjt1
         attz+VXTf5zRtn3csj29wPam48ldoGKp0NYybOlNX1GpyOOX3v8LlE4JexQO/8RK6c7a
         NgQ6CGNy1ew9X2NHtG7uWxDDo5JRIbHzo8Doj+CZky5lHAtmKTimHeJl5YMWVX4S5uMf
         KFlwVXnNpBruq381xZdKcVGr1XyQE8GKVxcYJB+7Hhg0/1JZyYLQiGAOJXvx/DCtJwT+
         nhGQ==
X-Gm-Message-State: AOAM531KaSwfopq1CwFN7zPK+oCU/Yk5H4WEhzve7bFpwkWb0LtJ8S8p
        N9AjJj28CV3wKhFFWz0kUgN5y6USdbqfQc8KPXLTUWfL/KyD4KjU1eQhEY1PHGQkbmtYr6VjI+2
        j7k9Vdo7SF1Bq
X-Received: by 2002:a1c:f207:: with SMTP id s7mr440848wmc.123.1589823430114;
        Mon, 18 May 2020 10:37:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHziqAUOZpnpSyz0zm5tqYhlwsJ/sYOxewftDlo7x0v61iHrJcJcl48zpv1zYNxvv9vqXjDw==
X-Received: by 2002:a1c:f207:: with SMTP id s7mr440825wmc.123.1589823429893;
        Mon, 18 May 2020 10:37:09 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.90.67])
        by smtp.gmail.com with ESMTPSA id k13sm265994wmj.40.2020.05.18.10.37.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 10:37:09 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: emulate reserved nops from 0f/18 to 0f/1f
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200515161919.29249-1-pbonzini@redhat.com>
 <20200518160720.GB3632@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <57d9da9b-00ec-3fe0-c69a-f7f00c68a90d@redhat.com>
Date:   Mon, 18 May 2020 19:37:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200518160720.GB3632@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/20 18:07, Sean Christopherson wrote:
> On Fri, May 15, 2020 at 12:19:19PM -0400, Paolo Bonzini wrote:
>> Instructions starting with 0f18 up to 0f1f are reserved nops, except those
>> that were assigned to MPX.
> Well, they're probably reserved NOPs again :-D.

So are you suggesting adding them back to the list as well?

>> These include the endbr markers used by CET.
> And RDSPP.  Wouldn't it make sense to treat RDSPP as a #UD even though it's
> a NOP if CET is disabled?  The logic being that a sane guest will execute
> RDSSP iff CET is enabled, and in that case it'd be better to inject a #UD
> than to silently break the guest.

We cannot assume that guests will bother checking CPUID before invoking
RDSPP.  This is especially true userspace, which needs to check if CET
is enable for itself and can only use RDSPP to do so.

Paolo

