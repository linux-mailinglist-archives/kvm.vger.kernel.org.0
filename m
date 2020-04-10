Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86211A4527
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 12:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgDJKYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 06:24:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22102 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725913AbgDJKYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 06:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586514239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hNMtqQDhqXxgBm2d6PtXUW4lIuPYaCAoH3YfelJDW6U=;
        b=QBAJGI1re6ltGL6uHg/jevWvpY2eCAigXEVtzOPx/smHg2AASykUJ3opGOQn+uI7p2egNJ
        g5bpNq5RxswlO8EKg13I5QvLwQE98PEot0A7LBSWxaQjPfcxNx6lHqsLJJWG2iNsjH9zE7
        pHOA2Gaxci+rWlGWwTaiB7/p0JPXaz8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-YJhd9QYwPYisDw2u3ihMtg-1; Fri, 10 Apr 2020 06:23:57 -0400
X-MC-Unique: YJhd9QYwPYisDw2u3ihMtg-1
Received: by mail-wr1-f69.google.com with SMTP id 91so937042wro.1
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 03:23:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hNMtqQDhqXxgBm2d6PtXUW4lIuPYaCAoH3YfelJDW6U=;
        b=Vzs52hOrSn0SWEaBeq9wBO/nANeMdnOyCAN0rZeMZwa3wR2dcV1NZ0sHfyIjrh1JHr
         +QZEDBjrPzOOp8Ciqer9eWGIQMLlagGo9gTsMqXbP+pXRzYYir4sFwapL+6zqG/aq3th
         wTvb75VWypXsNxQCwRm3bf2e3Z0P5J9RZQ2OXujTYagDB08rql/FwSHTh0uO3gb+SDLL
         4rAEWdWNZQJYZbZk59frtnxlTr39liNjIK0RewC5zZ9TCjboJSY9evQL1vI5UYXqLenB
         eWDpOiwiTdeH7e/es6iRdij1CBljLQrfpfijDy0qcotbP9zp6T/sxym2sSuCYGXKTeAD
         +fEg==
X-Gm-Message-State: AGi0PuYNmC7J7nLFwVLzWbVZPEKQpQL9YFTstfd+AvvItnh1cRbla6kq
        vPBsuV08tERsVdr503cCAnw2hWosDvO4pCGDhez9fZZP5ifbzJxiHsyh8NZGroDpIobXSUzuh5U
        n+FJoo1QFbI0V
X-Received: by 2002:a1c:7c18:: with SMTP id x24mr4211310wmc.146.1586514236350;
        Fri, 10 Apr 2020 03:23:56 -0700 (PDT)
X-Google-Smtp-Source: APiQypIIN+FhxOln9RGpZAOpqoKDY47mQ73YcDG4yKXz8RhDStd9eyiNr+jrcDR19FRJiAaG9lW/5w==
X-Received: by 2002:a1c:7c18:: with SMTP id x24mr4211297wmc.146.1586514236095;
        Fri, 10 Apr 2020 03:23:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e8a3:73c:c711:b995? ([2001:b07:6468:f312:e8a3:73c:c711:b995])
        by smtp.gmail.com with ESMTPSA id s14sm2303069wme.33.2020.04.10.03.23.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2020 03:23:55 -0700 (PDT)
Subject: Re: [PATCH 0/3] x86: KVM: VMX: Add basic split-lock #AC handling
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     x86@kernel.org, "Kenneth R . Crudup" <kenny@panix.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Nadav Amit <namit@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200402124205.334622628@linutronix.de>
 <20200402155554.27705-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b3f2a8d0-fa73-709e-8942-c1597184889f@redhat.com>
Date:   Fri, 10 Apr 2020 12:23:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200402155554.27705-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/04/20 17:55, Sean Christopherson wrote:
> First three patches from Xiaoyao's series to add split-lock #AC support
> in KVM.
> 
> Xiaoyao Li (3):
>   KVM: x86: Emulate split-lock access as a write in emulator
>   x86/split_lock: Refactor and export handle_user_split_lock() for KVM
>   KVM: VMX: Extend VMX's #AC interceptor to handle split lock #AC in
>     guest

Sorry I was out of the loop on this (I'm working part time and it's a
mess).  Sean, can you send the patches as a top-level message?  I'll
queue them and get them to Linus over the weekend.

Paolo

