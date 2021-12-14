Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E35D47408E
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 11:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhLNKhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 05:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbhLNKho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 05:37:44 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C61C061574;
        Tue, 14 Dec 2021 02:37:44 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id r11so60683834edd.9;
        Tue, 14 Dec 2021 02:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lr6Xm2QC9YDArVwqhtBi2Ode+GPvWUxMOzbZci3eiP0=;
        b=pWuiLPTehl9ZTKR5peC0IovISAwqKhwlgNWJN3qyvfzr54ZaPxIrCUcSTwvRQwErtx
         567lQL/B1wM1HOycaeOmQmi7HyK2dEa0ggxJ9N2AmbdqZ5SpG36loIUJRdQ0nh4tlgz/
         8C+aIW+3sNVqUXOEyVGbhbSz9xY3qtmTWBXuvx7CBAVunafEBq7DzNxKFujYxRtDK6ri
         BmX2XjWsdlvOzV5Q+xGJWhjpps61jqXSBqazvOn+stNa54j7tojNElOMR+o8oqaMhEGB
         OBA1ZBhkg6nElvoSlw2EG5LUdwR4ub0Sa+wIpXBs8WsAePO5iHfdTBno77XdsjBxRxv+
         NO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lr6Xm2QC9YDArVwqhtBi2Ode+GPvWUxMOzbZci3eiP0=;
        b=EWxapVXcK7qVVS3fKUy8+1JrW6DiV/fkAAvw3OPR30LAtaVZqeQ5KRtae4QirUKFvM
         WVUiw3gijsZa8n8StMIoVqSSbCymHr0oT90kUqgbIiUSXo8t7OJ7fW/pQY4fOmqSXVa+
         VZdtTY5MoShASFn02uXHtyZLvDGFauZ3Za+M9FXrXH3/XfUg9txh+Xd8xaR6dLdTR7r3
         fT4Aii+4OkCFhm2teHCSWiXaHZnt9U/tCp1gTKHB5Af5FJdU78WzfB547T+v3p9GEQMr
         aYv1IS3aMjcOXChl872EnnDMO0vFTuIiB6O8j9EUb0DJ/E5cs2qFVw4PBVNLPobFK6WN
         IbWw==
X-Gm-Message-State: AOAM533Fn6ywsLk06eFq1suPtKOA5+aKKpGqlHSQqpXZswcDaB2LPUVY
        Pkafmub7jQFs5O5cljAu484=
X-Google-Smtp-Source: ABdhPJzKeI8zLq1BYGJxj4+oiQm+3P+pfxxUMyFmzDuOLiqZka8t3V6cqUT1OG49Wqlu6ha0WMsmhQ==
X-Received: by 2002:a17:906:168e:: with SMTP id s14mr4697418ejd.340.1639478262976;
        Tue, 14 Dec 2021 02:37:42 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id f17sm7710765edq.39.2021.12.14.02.37.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 02:37:42 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <10514d6f-672b-5f1e-3af0-6eb641845c32@redhat.com>
Date:   Tue, 14 Dec 2021 11:37:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [patch 1/6] x86/fpu: Extend fpu_xstate_prctl() with guest
 permissions
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024947.818549574@linutronix.de>
 <BN9PR11MB5276B6158AC37CA38201D4308C759@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BN9PR11MB5276B6158AC37CA38201D4308C759@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/21 06:13, Tian, Kevin wrote:
>>    2) Permissions are frozen when the first vCPU is created to ensure
>>       consistency. Any attempt to expand permissions via the prctl() after
>>       that point is rejected.
>
> A curiosity question. Do we allow the user to reduce permissions?

No, there's no prctl for that.

Paolo
