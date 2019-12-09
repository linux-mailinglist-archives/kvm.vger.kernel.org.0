Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA5BB117259
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 18:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfLIRDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 12:03:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32733 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726342AbfLIRDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 12:03:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575911015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XZscNEm/8S7rYYR2nNxSKnziRbIDnKfxgL2hsBGVmf0=;
        b=PMrt/sQBnArGLIPTmegCW1ktQ87IKFbHJLRQM74GW9BnKoJR/H2PDYlI2Q/kznnaVmB2TE
        HLkWORSbOenpi++WWCdhRsQgW5MbLiqqsCY03bUL2nIEUsNH5BmHk66wSXDjfqtcd8xlqk
        WZ/uE36R+zOPyeKJYPhIIi9atZ7wGWY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-OqQ_I0h7OJiyevt3yePYYQ-1; Mon, 09 Dec 2019 12:03:34 -0500
Received: by mail-wr1-f69.google.com with SMTP id j13so7744684wrr.20
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 09:03:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XZscNEm/8S7rYYR2nNxSKnziRbIDnKfxgL2hsBGVmf0=;
        b=DZX8nGDqOB4ZteUpZzEmqvI65fKJ/76RLafP2Qx8pQyJ9Zea+YcyHtnYgq7KA3uVt0
         JmWTNO5J7C/iJExseJF5d+yTVnbtc4urcDz8f7fZKPgFFfX5Xifdk4QFbFWIeBxAF87f
         obm/AQuU6MBnxhIZsPeprIJBNZg5M53Nl3Ni9OwhMg20ZYrZFmRs5vbIbdpcbqDFKqHu
         6ECDRSD+OihlG2LNhITLuiAmcxI75UjcJhoCMabU6Fg8M0j49pwIPdXDl7gF2pTergfy
         xrBt56wI3c3eO1YNHrm2dOT6Zlq3waya3VwlSlZ+RFXCjbZIfPPXAaA4WTdYeD8H3od6
         ZKxA==
X-Gm-Message-State: APjAAAVFVOSL6uYwAue050ZIiAo7/IfHeUnH1nn5GSwkbOOoXk7kCHWh
        OznTIGiyKv+7jiKzw/4JwYg9sEnevoLl2+CAE9jnvu8u7XcunBbPSsra6YiV8SSwY3+Bk7TPEhI
        GlPsxy8/u77WP
X-Received: by 2002:a7b:ce98:: with SMTP id q24mr9566wmj.41.1575911013014;
        Mon, 09 Dec 2019 09:03:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqzDpR0s5SjlfMtDdgShxfdl9maDu+Un6Z+SFZJ5fcGr598GSHGZuwP95n0rBAgJvv9SZhP8JA==
X-Received: by 2002:a7b:ce98:: with SMTP id q24mr9536wmj.41.1575911012749;
        Mon, 09 Dec 2019 09:03:32 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id d12sm72894wrp.62.2019.12.09.09.03.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 09:03:31 -0800 (PST)
Subject: Re: [PATCH v4 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI
 fastpath
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>
References: <1574306232-872-1-git-send-email-wanpengli@tencent.com>
 <CANRm+CxYpPftErvk=JJdWZikKSn-PYsVRVP3LpF+Q3yBF8ypxg@mail.gmail.com>
 <CANRm+Cy_Aq4HY9vYDtBfoNyo8wikf8Mi3u7NBm=U78w1VtTFMA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9bc78a4c-6023-2566-d5ce-af611b199603@redhat.com>
Date:   Mon, 9 Dec 2019 18:03:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CANRm+Cy_Aq4HY9vYDtBfoNyo8wikf8Mi3u7NBm=U78w1VtTFMA@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: OqQ_I0h7OJiyevt3yePYYQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/12/19 09:15, Wanpeng Li wrote:
> kindly ping after the merge window. :)

Looks good.  Naming is hard, and I don't like very much the "accel"
part.  As soon as I come up with some names I prefer I will propose them
and apply the patch.

Paolo

