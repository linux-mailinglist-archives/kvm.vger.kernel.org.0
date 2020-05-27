Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000F31E4B1B
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 18:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731070AbgE0Q4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 12:56:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51271 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729914AbgE0Q4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 12:56:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590598567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=soqL+aLJQ94mC33SIvSHCVdyIZoJ3dhQDwVCjjCxaQQ=;
        b=SvQpnI9tpwQ0tlRMgNaMn4WDuvMDDDoCbG//9qrBn+w2SflkJFa0yxzJR1jdVDmYx4FExc
        dZqd8GzJOiKKjsgAaGvbHkIPKYguJKtf1h74woHckMPaKzS+m/e0+XfpVCNRgPzq0Mjn30
        4U672neBbjgqlMLqnGIwIoZcdsNcGBM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-MO9xKfyXP2usm-TIwT8WKw-1; Wed, 27 May 2020 12:56:05 -0400
X-MC-Unique: MO9xKfyXP2usm-TIwT8WKw-1
Received: by mail-wr1-f71.google.com with SMTP id j16so597864wre.22
        for <kvm@vger.kernel.org>; Wed, 27 May 2020 09:56:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=soqL+aLJQ94mC33SIvSHCVdyIZoJ3dhQDwVCjjCxaQQ=;
        b=MnpEWNCUYjGFcbsNPGQ9FVYJR/ybVO4VVVuXFI3apPSh6toNKNebeAwq5+yftZFoSp
         GhDUfERtTsr0oKPgGpgTItXUF1D3bWrG9yvdY0SFASAKpawO+6R+5CiE3IXkGOpcGY8L
         1AHMVsPsJCzaiIp1cmkJKZyOI6YOVfmp1CPkJ7hjP6S7Gw/Ti/vlTUiXyyhvSC5vTkYL
         shwDizb1ctidKecOWfci43iPAzhdQ1MRQvw1dkKTmGIKSSU29pjrlRsV2ZTX24cVdxzm
         WX8Eb6+1lgE4EXS50Bf/T5wBxjKpscjS1W3EViNZaWtYyzAZthzAyfCxypndYLc/+n5/
         fPTQ==
X-Gm-Message-State: AOAM533qlKUurTdGfB8meyRzEJqo30oCChJPhRWHzh6ZuvIQQLEj34Qj
        Z5H4CHtczXeteItWCsKtSBOYFqM97mscyTFEtiC8/Pc1dIbp9OpFoUny1VS9hgGbNGfqTO632t9
        cev1I+dZKlXfS
X-Received: by 2002:adf:82d0:: with SMTP id 74mr23661153wrc.138.1590598564716;
        Wed, 27 May 2020 09:56:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxN1ltZI5oKhQFxqvF5DXCav71j97g6FqnxePCMKk31xs5VPQBfCIzOpFoJ7nuCJZDpjSSiNQ==
X-Received: by 2002:adf:82d0:: with SMTP id 74mr23661135wrc.138.1590598564454;
        Wed, 27 May 2020 09:56:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id d5sm3351651wrb.14.2020.05.27.09.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:56:03 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Initialize tdp_level during vCPU creation
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+904752567107eefb728c@syzkaller.appspotmail.com
References: <20200527085400.23759-1-sean.j.christopherson@intel.com>
 <875zch66fy.fsf@vitty.brq.redhat.com>
 <c444fbcc-8ac3-2431-4cdb-2a37b93b1fa2@redhat.com>
 <20200527162318.GD24461@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e2b9d767-df19-2974-8457-737b925749d3@redhat.com>
Date:   Wed, 27 May 2020 18:56:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200527162318.GD24461@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/20 18:23, Sean Christopherson wrote:
> Hmm, one option would be to make .get_tdp_level() pure function by passing
> in vcpu->arch.maxphyaddr.  That should make the comment redundant.  I don't
> love bleeding VMX's implementation into the prototype, but that ship has
> kinda already sailed.

Well, it's not bleeding the implementation that much, guest MAXPHYADDR
is pretty much the only reason why it's a function and not a constant.

Another possibility BTW is to make the callback get_max_tdp_level and
make get_tdp_level a function in mmu.c.

Paolo

