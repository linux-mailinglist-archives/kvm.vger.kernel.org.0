Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DF6267830
	for <lists+kvm@lfdr.de>; Sat, 12 Sep 2020 08:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgILGUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Sep 2020 02:20:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbgILGUW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 12 Sep 2020 02:20:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599891620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wtddZ/g5BzSG6r0hO9D5GNe6gRNbI691h+YLFCj4YNs=;
        b=GKHJMYtFFhAldoL9QfLC8fWgUvVuq8kB/+2vP0ADLPfHTUoFm66QZbw6evH3ro6ycHdAmO
        7FH099TNrf1ymQGv1eJiTmViKrs6VfuLGcY3hr+129HS5FDynSCh+j3FUzlezu33U7Tx9J
        bXy+omDO9FkT4AUW49oRRXGsr+fjfdg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-zgUyBcxeOQCG1LXVaf_ZEA-1; Sat, 12 Sep 2020 02:20:18 -0400
X-MC-Unique: zgUyBcxeOQCG1LXVaf_ZEA-1
Received: by mail-wm1-f72.google.com with SMTP id x6so1686689wmi.1
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 23:20:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wtddZ/g5BzSG6r0hO9D5GNe6gRNbI691h+YLFCj4YNs=;
        b=S6wEo9+M5f39lYzLoyMgPYJeQ8behC7A79bJN4b/CTRNKvQIKzkyj6pNjWk8ruJRgn
         9lT/Zhv2nBUzPhL5j0muHNABvm40RjPjx9d04iBqGhIKj+mw5KOJiCqQ6uSpj1VFXinQ
         PUtaEstQb+DlfH5E1wSGj0Vo/72P+SrUb3/g1K11JWplGJjFgmiW+cnAEZEsloLVH3Xa
         I2ASWWprAAso/A6ZsLQvWdPUVUT7VUVAmZVZLmgSioch53tnGK2D7NFpzRX701pXggAX
         so8sMKOq4ofhB1lyHB4Y1Uv8Y19lW7G0rE+wu0D5I/37zUCPSTWPRxa3sDKEGbHQ75Yu
         NK1A==
X-Gm-Message-State: AOAM532DwVPUMme6utwsNxzF9i25ZFCQx3lVlVmpmp0jBOOkdZcdFTPv
        n/d+UdszhIWy9tE3xBGtH1OQRXnafm9DcqlqUUpqdg+rqWQ9AupH1WRIh88ndlFcpmvGjTepZ23
        jq9L8htDpdEHY
X-Received: by 2002:a1c:e3c3:: with SMTP id a186mr525472wmh.189.1599891616755;
        Fri, 11 Sep 2020 23:20:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3J9onSbFlnBmb71KhpXE0SnDHzaeYgliqwQ1/UJzyJ+sCi/4G2rJz2kHw7uY91FM3JgxYsw==
X-Received: by 2002:a1c:e3c3:: with SMTP id a186mr525461wmh.189.1599891616575;
        Fri, 11 Sep 2020 23:20:16 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id u66sm8430591wmg.44.2020.09.11.23.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 23:20:16 -0700 (PDT)
Subject: Re: [PATCH 2/3] KVM: SVM: Move svm_complete_interrupts() into
 svm_vcpu_run()
To:     Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Paul K ." <kronenpj@kronenpj.dyndns.org>
References: <1599620119-12971-1-git-send-email-wanpengli@tencent.com>
 <87eenbmjo4.fsf@vitty.brq.redhat.com>
 <CANRm+CxR=U1jYMsqGEUOJ+G6ekUs3igZxzNzrepHp17QYrcEnw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a9ae6d3d-e616-58c5-5db5-149fb702631f@redhat.com>
Date:   Sat, 12 Sep 2020 08:20:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CxR=U1jYMsqGEUOJ+G6ekUs3igZxzNzrepHp17QYrcEnw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/09/20 10:47, Wanpeng Li wrote:
>> One more thing:
>>
>> VMX version does
>>
>>         vmx_complete_interrupts(vmx);
>>         if (is_guest_mode(vcpu))
>>                 return EXIT_FASTPATH_NONE;
>>
>> and on SVM we analyze is_guest_mode() inside
>> svm_exit_handlers_fastpath() - should we also change that for
>> conformity?
> 
> Agreed, will do in v2.

Please just send an incremental patch.  Thanks!

Paolo

