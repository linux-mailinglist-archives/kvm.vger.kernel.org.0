Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A8C927E6
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 17:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfHSPEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 11:04:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727782AbfHSPEW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 11:04:22 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AD6CD3CA20
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 15:04:21 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id f9so5387696wrq.14
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 08:04:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HblrU59w7iq0IMa0UwOfQFmKlzPCrtNFnI+Yo74xiP0=;
        b=sIoaQ7qTx0+dcVqUhvbXBgItoLcmG/BQv4+xdERh5lB9TvxtE2vX4n5WiWexSaLHaJ
         LDJPjLXffjAJ6QJw5bkK2wM9TYHUVRFC0qr0wb/SouLIMKHUnpEq+OCPEc/ezQxpPhjt
         y6uIBdRBrX+wAjB6IGiUpcXTlMQX3P4nZ9eTD661uJ676GkiX8TNpEQfXtJjaG9zxrzc
         tLGJwLTKUf6Fsp0CAkDDRFpt66hhRXn68P5XiLEZIQq81S6qQt4hjkoZcespi7ffHU7k
         qDbh8ikCu8UyImuGMfW9lLRRCCCdRXP2yQv3eIXBt9X/50DIrr+0RFBB2kz7AltthU6R
         wopg==
X-Gm-Message-State: APjAAAXBC/4xjWGNQ6GGLV2GTi4ls0XN4HmZyxyuw3ocIzdPLfJVHQZl
        EQdrVltEdNk0/QC+uF+oi0O/SelDsDV2mpgqWmbBYmO0yLfWa1+E8g77L4pJxsXsmst1LMURkGz
        qV27XGpt/EPwn
X-Received: by 2002:a1c:e487:: with SMTP id b129mr21681022wmh.93.1566227060298;
        Mon, 19 Aug 2019 08:04:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzc0OtOrqlpeTuYSxWjcfe1kG3/vPGvpzncWKT+VMlrsoY9w3cJ3MW5RDu5K18iSOaFwLnScg==
X-Received: by 2002:a1c:e487:: with SMTP id b129mr21680981wmh.93.1566227060020;
        Mon, 19 Aug 2019 08:04:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8033:56b6:f047:ba4f? ([2001:b07:6468:f312:8033:56b6:f047:ba4f])
        by smtp.gmail.com with ESMTPSA id r190sm17085048wmf.0.2019.08.19.08.04.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2019 08:04:19 -0700 (PDT)
Subject: Re: [PATCH RESEND v4 7/9] KVM: VMX: Handle SPP induced vmexit and
 page fault
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <20190814070403.6588-8-weijiang.yang@intel.com>
 <5f6ba406-17c4-a552-2352-2ff50569aac0@redhat.com>
Message-ID: <fb6cd8b4-eee9-6e58-4047-550811bffd58@redhat.com>
Date:   Mon, 19 Aug 2019 17:04:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5f6ba406-17c4-a552-2352-2ff50569aac0@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/08/19 16:43, Paolo Bonzini wrote:
>> +			/*
>> +			 * Record write protect fault caused by
>> +			 * Sub-page Protection, let VMI decide
>> +			 * the next step.
>> +			 */
>> +			if (spte & PT_SPP_MASK) {
> Should this be "if (spte & PT_WRITABLE_MASK)" instead?  That is, if the
> page is already writable, the fault must be an SPP fault.

Hmm, no I forgot how SPP works; still, this is *not* correct.  For
example, if SPP marks part of a page as read-write, but KVM wants to
write-protect the whole page for access or dirty tracking, that should
not cause an SPP exit.

So I think that when KVM wants to write-protect the whole page
(wrprot_ad_disabled_spte) it must also clear PT_SPP_MASK; for example it
could save it in bit 53 (PT64_SECOND_AVAIL_BITS_SHIFT + 1).  If the
saved bit is set, fast_page_fault must then set PT_SPP_MASK instead of
PT_WRITABLE_MASK.  On re-entry this will cause an SPP vmexit;
fast_page_fault should never trigger an SPP userspace exit on its own,
all the SPP handling should go through handle_spp.

Paolo
