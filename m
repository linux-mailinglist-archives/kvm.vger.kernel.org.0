Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0346B27955B
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 02:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbgIZAGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 20:06:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725208AbgIZAGR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 20:06:17 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601078776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lr4vbSW2IrU7YXNvvxdULdw0XL39ouWApcz+hc4IwGY=;
        b=Bi5L1tWrTwi0F5fDJz5ums5nt9LXyq/UTazCWuz1gUaAFRJteD4eJnoJ6Nk4QQmd2ooMPv
        jh8xBUSeUQMrbne3KLT+NbLeROkCzX9Gq8vkgxG3w7Pt/upbHBIOkWIN1CnkGWtQ21P8B7
        KQd7TaXRT2ci0JuYojM+HsuTbdSfvyg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-6ft7QWgbPE2jmcUyVzZ6Eg-1; Fri, 25 Sep 2020 20:06:14 -0400
X-MC-Unique: 6ft7QWgbPE2jmcUyVzZ6Eg-1
Received: by mail-wr1-f69.google.com with SMTP id b7so1714171wrn.6
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 17:06:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lr4vbSW2IrU7YXNvvxdULdw0XL39ouWApcz+hc4IwGY=;
        b=OweZoqDrdPGrsmXAP11uSCOvQLDikd8lIB9jjZbolOSAcy07vVPDbLcHgLUlSB6aX/
         QBrSrEpWAECROMvK2J4tefoogejLiX8DngrnscbW/fYLR6LssfhJMnCJLWxNxogJObI+
         MfPMpzgLgUdWcfCH822V8MzkFgWcD7iIjR4ZRTR11CO0JdMXbaxOitXsLXMUg7nm1O80
         a0eSR4o8ZbFDqW/onCbQaXufs/ozt+Kdu+4pFloK7caOv09ptCryzOlQixIMTGj35bUk
         +nLeYOV8m5oHGezX5fiwCyBV1/a81fcUmNPLyuZxXaLcR8XYZTqK+5A+mwDjJCWfbJhS
         7WJQ==
X-Gm-Message-State: AOAM531a/fTt/Llw5QwNpbZsOI87paLjY6ici56Ch16Xrptq1/FLzKDG
        zEk2lrz0dFSxLW59jMmSv8qiXSqBVDMeymsMachRfhPtWi0IWBXEPgUdajFfO6Su5j6tCPrOdWj
        eZ2DZQ3bz9odt
X-Received: by 2002:adf:fa02:: with SMTP id m2mr6812369wrr.273.1601078773712;
        Fri, 25 Sep 2020 17:06:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzaa34YmgMwKOPjOfXUAohWrRIyHfLKN5vteiY20bqkr8oDd5O0O/4vWVwGsXKBL2VSp9N5WQ==
X-Received: by 2002:adf:fa02:: with SMTP id m2mr6812338wrr.273.1601078773469;
        Fri, 25 Sep 2020 17:06:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id u63sm681508wmb.13.2020.09.25.17.06.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 17:06:12 -0700 (PDT)
Subject: Re: [PATCH 03/22] kvm: mmu: Init / Uninit the TDP MMU
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
 <20200925212302.3979661-4-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <22ffacb6-7040-1869-0c69-3d99f2f1e044@redhat.com>
Date:   Sat, 26 Sep 2020 02:06:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925212302.3979661-4-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 23:22, Ben Gardon wrote:
> +static bool __read_mostly tdp_mmu_enabled = true;
> +module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
> +

This would need some custom callbacks to avoid the warning in
is_tdp_mmu_enabled().

Paolo

