Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2389E11D257
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 17:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729916AbfLLQbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 11:31:53 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43249 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729863AbfLLQbw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 11:31:52 -0500
Received: by mail-qt1-f194.google.com with SMTP id b3so2749302qti.10
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 08:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5nxGnUdtw58bWHogUzbvsjBU/PDGHKaobG6uElnGLno=;
        b=oa9rL5G/dbfnIV/LzrzoNnyRhtYmlptMoi+t69zugwSNSWgp9blS+XEl+9/0hsU8g4
         wEvlkxhrXfv//LqB2RXF1LitoGfhsbCkWj/Z5CkEmM96cg+UQbdGImwjCbcHoIJMMNj+
         sljAkxcEM8qhYEWlMb93V1Xx85g7RTRnV35Wu3xroUX1iVIdvJLWKvrBy79W0q0hUiVi
         X3/dugi+HFn6kRO6XlCj5Wu2KE6/5NrV285cbLrOGt6N6OYzb6ULcMDIc/F6pZ2s7ZbE
         VSVXgaZMKyImgmEl28wIXQzlvsJ5qIjNjk1tyKd4jJLcuPBrdarAFLv/PrC8tUBEusL0
         wt2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5nxGnUdtw58bWHogUzbvsjBU/PDGHKaobG6uElnGLno=;
        b=LP9Ym3Zy8hS0MUYKXilzibm8MhnS7aRtOV0FgxIBcvKIndgqS3tzDekhy9yUIO0Y7U
         SU3vlkDZKzAVmQnTn1UL8P1Awsj8y75p/dokMDCjxaL+epcX58CHd/faxi6v0Z53eWBa
         pshTevCQlF5jr3Cp7c2V5QdSbQ0SBo6zIYZ8DqoHSM96nKqmnHBwBJdFG417dmcBJawL
         S+u0WY6MKXWqduWTl09swE3x/gGyxnjqw3igwFJuXMLCI6Zs7fOl3ZO1z2WdcRC1npfX
         rFkscusVzTNJkEHOuiLd3cJUGwdHqthUnkr7lt1KCyBI0hP0oJi2Dxey/p59cHxRIic7
         VdsQ==
X-Gm-Message-State: APjAAAXJDtmnq805ejLC/dCPrweZJkDgyfet5gMVm7TI6ohVuiRp40hJ
        bE+yaD/b2sy3QT0QmBQf9ThvJQ==
X-Google-Smtp-Source: APXvYqyfo7q7u1Qo2RWrsYPgxg4cCPsnEGuVFjYRp2T2M/zKAnej0anX24hFu358xW7EyeiV/RdLyw==
X-Received: by 2002:ac8:3177:: with SMTP id h52mr8535747qtb.264.1576168311701;
        Thu, 12 Dec 2019 08:31:51 -0800 (PST)
Received: from ?IPv6:2620:0:1004:a:6e2b:60f7:b51b:3b04? ([2620:0:1004:a:6e2b:60f7:b51b:3b04])
        by smtp.gmail.com with ESMTPSA id t38sm2355441qta.78.2019.12.12.08.31.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 08:31:51 -0800 (PST)
Subject: Re: [PATCH v4 2/2] kvm: Use huge pages for DAX-backed files
To:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
References: <20191211213207.215936-1-brho@google.com>
 <20191211213207.215936-3-brho@google.com>
 <eb9ef218-1bbc-83e6-ec84-c6aae245e62b@redhat.com>
From:   Barret Rhoden <brho@google.com>
Message-ID: <c203f44c-d5b0-429d-0c13-5723c09ec243@google.com>
Date:   Thu, 12 Dec 2019 11:31:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <eb9ef218-1bbc-83e6-ec84-c6aae245e62b@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/19 7:22 AM, David Hildenbrand wrote:
>> +	/*
>> +	 * Our caller grabbed the KVM mmu_lock with a successful
>> +	 * mmu_notifier_retry, so we're safe to walk the page table.
>> +	 */
>> +	switch (dev_pagemap_mapping_shift(hva, current->mm)) {
>> +	case PMD_SHIFT:
>> +	case PUD_SIZE:
> 
> Shouldn't this be PUD_SHIFT?
> 
> But I agree with Paolo, that this is simply
> 
> return dev_pagemap_mapping_shift(hva, current->mm) > PAGE_SHIFT;

Yes, good call.  I'll fix that in the next version.

