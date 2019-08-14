Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C16E08D341
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 14:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfHNMge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 08:36:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36992 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727157AbfHNMge (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 08:36:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id z11so9003725wrt.4
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2019 05:36:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wuVjOoaxyYfyWJnYmRPjrLbRW1mIiUBjkOasfY9prsg=;
        b=OXm0cq+Hvsfn09lttjTeGcQ7w5bbW0BmY2z7XGRKqRGEUWGEJw6EypnGZMap+Tnd1N
         HneGoHiJd4X5ubxlDlR7DY4DAVOpDwUWN2TU0v1HkBHncq/GKyy0xVmSd3T6wmp4+Zti
         nREdTgjF0lwDiR2K6jelYcbZMTaTjF3v0qOS4VPJHwRF/bSW03XSteI+w0tRJ6fau2Ez
         wnpPjQI1hFht7HFCGEN01itwKInl9E+0oAlo4xZqvbiW9/BpDVXDxZZDVvRuYVWwQBII
         KwVTMF8JAH7ZTaXoUkGrN5c/2+cfnlK3KPN3psJFOMjzX8Dbtx5EDAKU5MQm/LwDF074
         ai5g==
X-Gm-Message-State: APjAAAV5UGn+O1qTaR31Ukpi6TSfA4u9p2AUJaIb2vaFTcdEzwjvtlgo
        w09hiEmKKHjdQvbvTj+Ykboz7A==
X-Google-Smtp-Source: APXvYqzLtPHooUoQICvLxBgMLkG+W6Oap3eOZe4rPwxKBzM0VTPkTbcjTvwNLTRNTTKwxrSX7/UREw==
X-Received: by 2002:adf:f6d2:: with SMTP id y18mr51783258wrp.102.1565786191460;
        Wed, 14 Aug 2019 05:36:31 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 2sm3572989wmz.16.2019.08.14.05.36.30
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 05:36:30 -0700 (PDT)
Subject: Re: [PATCH RESEND v4 0/9] Enable Sub-page Write Protection Support
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com
References: <20190814070403.6588-1-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5db7a1fc-994f-f95b-5813-ffe1801dbfbc@redhat.com>
Date:   Wed, 14 Aug 2019 14:36:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190814070403.6588-1-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/08/19 09:03, Yang Weijiang wrote:
> EPT-Based Sub-Page write Protection(SPP)is a HW capability which allows
> Virtual Machine Monitor(VMM) to specify write-permission for guest
> physical memory at a sub-page(128 byte) granularity. When this
> capability is enabled, the CPU enforces write-access check for sub-pages
> within a 4KB page.
> 
> The feature is targeted to provide fine-grained memory protection for
> usages such as device virtualization, memory check-point and VM
> introspection etc.
> 
> SPP is active when the "sub-page write protection" (bit 23) is 1 in
> Secondary VM-Execution Controls. The feature is backed with a Sub-Page
> Permission Table(SPPT), SPPT is referenced via a 64-bit control field
> called Sub-Page Permission Table Pointer (SPPTP) which contains a
> 4K-aligned physical address.
> 
> Right now, only 4KB physical pages are supported for SPP. To enable SPP
> for certain physical page, we need to first make the physical page
> write-protected, then set bit 61 of the corresponding EPT leaf entry. 
> While HW walks EPT, if bit 61 is set, it traverses SPPT with the guset
> physical address to find out the sub-page permissions at the leaf entry.
> If the corresponding bit is set, write to sub-page is permitted,
> otherwise, SPP induced EPT violation is generated.

Still no testcases?

Paolo
