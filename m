Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF06F455EDA
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhKRPEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:04:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21582 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229490AbhKRPEf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 10:04:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637247695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SxrEg7UW7qWAEoOqB1zEtLcuS6IkgdagZ+fjVsWZWbk=;
        b=M/FyNTnc2uLBhDZwgtA8snEXxiHyQWdM3WG0+E51lEcrYEAMv26Ke/Ou3OpxzadS3gNcCC
        LyzsrYp688V8DRqJfzTaTShKUyUsQXKNAOKwtGoU+HHLdmB25JvV7GWsVaYPAGMgOthFuc
        lvGr/IA/JvjajMDGeYw29pO74GIYKCc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-xH7Xow_OOPOQhDWsKeqJVg-1; Thu, 18 Nov 2021 10:01:32 -0500
X-MC-Unique: xH7Xow_OOPOQhDWsKeqJVg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FD741054F91;
        Thu, 18 Nov 2021 15:01:30 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57D0519811;
        Thu, 18 Nov 2021 15:01:25 +0000 (UTC)
Message-ID: <65e1f2ca-5d89-d67f-2e0e-542094f89f05@redhat.com>
Date:   Thu, 18 Nov 2021 16:01:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 15/15] KVM: X86: Always set gpte_is_8_bytes when direct
 map
Content-Language: en-US
To:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
 <20211118110814.2568-16-jiangshanlai@gmail.com>
 <16b701db-e277-c4ef-e198-65a2dc6e3fdf@redhat.com>
 <bcfa0e4d-f6ab-037a-9ce1-d0cd612422a5@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <bcfa0e4d-f6ab-037a-9ce1-d0cd612422a5@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/21 15:34, Lai Jiangshan wrote:
> 
> 
> On 2021/11/18 19:12, Paolo Bonzini wrote:
>> On 11/18/21 12:08, Lai Jiangshan wrote:
>>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>>
>>> When direct map, gpte_is_8_bytes has no meaning, but it is true for all
>>> other cases except direct map when nonpaping.
>>>
>>> Setting gpte_is_8_bytes to true when nonpaping can ensure that
>>> !gpte_is_8_bytes means 32-bit gptes for shadow paging.
>>
>> Then the right thing to do would be to rename it to has_4_byte_gptes 
>> and invert the direction.  But as things stand, it's a bit more 
>> confusing to make gpte_is_8_bytes=1 if there are no guest PTEs at all.
>>
> 
> I will make the last 3 patches be a separated patchset and will do the 
> rename.

Patches 13 and 14 are fine actually.

Paolo

