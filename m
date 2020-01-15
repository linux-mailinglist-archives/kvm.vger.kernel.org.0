Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD3413CBFA
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 19:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgAOSU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 13:20:27 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38940 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728904AbgAOSU1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jan 2020 13:20:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579112426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=17zGvszpS2X4BFkl2CiCggkEpVm2B9z6sEshLBKqEMs=;
        b=e3fFBVzOGQ2wSbLrL/7aqB7uE6xZP2JesqEilcrcdvH6kHNchFe79DSCK8K0I3GkMHXFR+
        J9danh0Wr7Uumhy9U6LJ7+XG4EXy2unX1O/kseicAdfRZ0vDFLUkIoae+fWTp850Sn6rRp
        1HrgeeZwRADkpFPn2BIBRiqh+HkrX1s=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-0ph5h0x0NuOE7LIwPczYnA-1; Wed, 15 Jan 2020 13:20:24 -0500
X-MC-Unique: 0ph5h0x0NuOE7LIwPczYnA-1
Received: by mail-wr1-f69.google.com with SMTP id h30so8281368wrh.5
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 10:20:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=17zGvszpS2X4BFkl2CiCggkEpVm2B9z6sEshLBKqEMs=;
        b=XfcFN9xWUPv/yO5P+n85ydCTSi/hynAFgz/jWsNTm0dn6BONN2CC+jDS9voMXzmP0i
         ZGzUbar3bZovwG3dE6urq6GGiCqnG5oBJIsEXeoIfSkbZFxuFTQYhPAiuAnQKyAblFQB
         UFO3lNob1NvlPD8ONezCdsWVt2RWtVmAYX2JxcQm473Oy6kosdoc3d9iTUO0jxnTcDnK
         3Wb2qqaUKNB8ej5twR6kjXmU7cyHpUOmoMJT7BRMpMbG9TbEsimQnzfwTqkAsCdRo+qc
         u1Sb4c0zBft+s6l9F9ZteIQ9vu6d7zjOgpp7eH5fTfar4pK/g8aLetVtJoJsM5JyM7ua
         10eg==
X-Gm-Message-State: APjAAAU5gzPvYFRYHcUKmtfxDalWh0obx8RzbXeyNAC7eWCjWDtH9VBk
        dfrRH/dCrpcX0d2f3xDrgEwR56pvRLn8MV/1E9jbd4tKtTZX8LlwcXBEmmdhjzFI8Zu4+Dc/AQC
        /IA3BcsCzUYfy
X-Received: by 2002:adf:eb46:: with SMTP id u6mr33317277wrn.239.1579112423904;
        Wed, 15 Jan 2020 10:20:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqw/Qyejk/Pe57hiihIWH7LtW6xhsVMRE5PFvyRvUxM72lwLh4/4yWAz6JdsH05250/GZ594wQ==
X-Received: by 2002:adf:eb46:: with SMTP id u6mr33317258wrn.239.1579112423623;
        Wed, 15 Jan 2020 10:20:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:436:e17d:1fd9:d92a? ([2001:b07:6468:f312:436:e17d:1fd9:d92a])
        by smtp.gmail.com with ESMTPSA id e6sm26800599wru.44.2020.01.15.10.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 10:20:22 -0800 (PST)
Subject: Re: [PATCH] KVM: x86/mmu: Fix a benign Bitwise vs. Logical OR mixup
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200108001859.25254-1-sean.j.christopherson@intel.com>
 <c716f793e22e4885a3dee3c91f93e517@AcuMS.aculab.com>
 <20200109152629.GA25610@rani.riverdale.lan>
 <20200109163624.GA15001@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <41a2328e-a64a-0131-920e-06328305919d@redhat.com>
Date:   Wed, 15 Jan 2020 19:20:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200109163624.GA15001@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/01/20 17:36, Sean Christopherson wrote:
>>> You also don't want to convert the expression result to zero.
>> The function is static inline bool, so it's almost certainly a mistake
>> originally. The != 0 is superfluous, but this will get inlined anyway.
> Ya, the bitwise-OR was added in commit 25d92081ae2f ("nEPT: Add nEPT
> violation/misconfigration support"), and AFAICT it's unintentional.

It may not be intentional in this case, but it's certainly the kind of
code that I would have fun writing. :)

Paolo

