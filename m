Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D3F1B5FC8
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgDWPpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:45:14 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37434 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729139AbgDWPpN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 11:45:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587656712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o/eyK+EbSaVmWgGDTgI5XBVI7nXdlbx2Mfw1lzGhFR0=;
        b=HtxM9YmlaGKBiYvd/fTpzCCshiGM/eHo99UyXZk69F4XyAT+UlRArLdFgrrlyte5lS7Dgx
        YLP0msIvDCAEzkbayeeiuXaAmnmcvahP/HnaWnbZZK+J6Ioc/ZH8iybf+c3ap891aZcZyG
        n7PNvMNWvw6lrN1ci8v8wAjdUSvDY6s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-injz_3YsOuqJnNPWsgYloA-1; Thu, 23 Apr 2020 11:45:10 -0400
X-MC-Unique: injz_3YsOuqJnNPWsgYloA-1
Received: by mail-wr1-f70.google.com with SMTP id p16so3060782wro.16
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 08:45:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o/eyK+EbSaVmWgGDTgI5XBVI7nXdlbx2Mfw1lzGhFR0=;
        b=m5eStE+9wbKSZ1+ZAvKgOnTC1v2Wn/4aTn2R9RMADyjF6FlnDzixXW4muS4TD4ZWkp
         yo6wQgsHphlwSB+hTH8oHStdd6cHmZE7jcuU9D5ulBNWusAxcD4TRXGpmryoDj74VmVD
         6MFdiUwemmHW7JqUYBkZIgCntVpeNV+K35uSHJ89xsvpzA9muawGB55yFnjLunwKjekG
         3M1CdokLdpVq5C5cCSidwVJ3HZ6Taaenr7gFiIsmzPAbXy0xE40xFjnNnSZux3RcORf+
         YSovhz94w1woRBOrzcmiYiXJXSUtbX2PQr1Yc5vV6e2joVCZZ1bJdnWAxVqbuUsPlBJ3
         p0ww==
X-Gm-Message-State: AGi0Puay5fV3QumIDAR6EcPcziSNTqqBzlmqARbYKnztatkAKM+mwknH
        idwcSa61hnsOK3D2HFHn9898lDjYAMBFMT5mPgEem1BNXoxnKktYipjQEbkDD0xkE0FRvqpxtYI
        YHM234Tp38r6r
X-Received: by 2002:a5d:4ed1:: with SMTP id s17mr5521553wrv.310.1587656709292;
        Thu, 23 Apr 2020 08:45:09 -0700 (PDT)
X-Google-Smtp-Source: APiQypJQIWjb+dZw7q23LstnoGqkWnnG7jTTPRc3d17WOFTrkOrZ7Cz8Lu6tsmp8q4JwNsmEAyDl6w==
X-Received: by 2002:a5d:4ed1:: with SMTP id s17mr5521534wrv.310.1587656709102;
        Thu, 23 Apr 2020 08:45:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id q184sm4116644wma.25.2020.04.23.08.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 08:45:08 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86: check_nested_events if there is an
 injectable NMI
To:     Cathy Avery <cavery@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, wei.huang2@amd.com
References: <20200414201107.22952-1-cavery@redhat.com>
 <20200414201107.22952-3-cavery@redhat.com>
 <20200423144209.GA17824@linux.intel.com>
 <467c5c66-8890-02ba-2e9a-c28365d9f2c6@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <28f3db39-4561-7873-09dc-a27ebe5501b6@redhat.com>
Date:   Thu, 23 Apr 2020 17:45:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <467c5c66-8890-02ba-2e9a-c28365d9f2c6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 17:36, Cathy Avery wrote:
> 
> You will have to forgive me as I am new to KVM and any help would be
> most appreciated.

No problem---this is a _really_ hairy part.  At least every time we make
some changes it suddenly starts making more sense (both hacks and bugs
decrease over time).

Paolo

