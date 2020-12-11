Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B3E2D814B
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 22:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406202AbgLKVvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 16:51:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35689 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393025AbgLKVuy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 16:50:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607723364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zuczDP3rlDg+1gIk7tYHPGxKD84Ww8Vb8YLolRymw1E=;
        b=Yb3n7p9rrYq1cn/n2gjsqQDZ6f9sI2WEh4l/LSwTZDfXwLK+/heQVYQe/O/jbC2/ah6Bwk
        HEtOcJ2kl7ENN2EuzWQCo0Tzj7o/sowqsAxAMqvALd6TDKQGN1o2kKFOl7bwhFcT3EP2bw
        WiujvfhxHU1iYLrr/F6VzKkMRzF1+gI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-XhW1WGd4M86Fx8bEXc7YgQ-1; Fri, 11 Dec 2020 16:49:21 -0500
X-MC-Unique: XhW1WGd4M86Fx8bEXc7YgQ-1
Received: by mail-wr1-f69.google.com with SMTP id v1so3826094wri.16
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 13:49:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zuczDP3rlDg+1gIk7tYHPGxKD84Ww8Vb8YLolRymw1E=;
        b=PN3SqF4gz+4SOWZgtHeNhQHMpXihIizfXjLzOM1dEQngjlSymwPOLw3nGhml3hRzPJ
         wk1P3gJQWPHduz483gRftX3KYgvoFK8hLq5Q+4/AEaK3fyzdtUuJfQj+8IL/YHKktU6y
         bUswv3+fkarJ5W67CTVf0eqINMVA07xFyUjsVG3lVA7R9yprRyOZFECjmlLKmns9iABD
         Q622/FhJLIFa9PfGPz1VmZ8ik790CxrJLXgwVJUCa/k8Y95f0MFrLCCvlyw3ULq0FNSD
         XuHeWk0TBGycf8zfL/CEp25QMXPc10Bgsnt5hCTSEiqCtoKxRqc/kvNsLPLQTQHHElXU
         pRyw==
X-Gm-Message-State: AOAM531awyh6Sdy8y7ffAiWD94Ar3Bnkmt+Ov9WWX5Wkcnoi6uHcU4vH
        UJJuXXvZjouvKNyMt9IZugaIUNN6bZEV5EoowgZazSN1G7FAA4gY8oCTENWP2JXmj+fFpiGY2xZ
        lkq8DlUltF+m6
X-Received: by 2002:a5d:554e:: with SMTP id g14mr16259382wrw.264.1607723360372;
        Fri, 11 Dec 2020 13:49:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyp9O8KaTlxS9WiIfSRbc0GS8E6srYLo1peTpBJKxqoKM0bWmQHn8t4KP4a/gjQhgnBhpfCDw==
X-Received: by 2002:a5d:554e:: with SMTP id g14mr16259372wrw.264.1607723360229;
        Fri, 11 Dec 2020 13:49:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n17sm15635202wmc.33.2020.12.11.13.49.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 13:49:19 -0800 (PST)
Subject: Re: [PATCH 1/2 v4] KVM: nSVM: Check reserved values for 'Type' and
 invalid vectors in EVENTINJ
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com
References: <20201207194129.7543-1-krish.sadhukhan@oracle.com>
 <20201207194129.7543-2-krish.sadhukhan@oracle.com>
 <X86N2c7ZG5fAToND@google.com>
 <76431b0c-4add-79b5-3f62-9c15306a1421@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dac77325-7127-c8f2-4bb6-03210407c15a@redhat.com>
Date:   Fri, 11 Dec 2020 22:49:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <76431b0c-4add-79b5-3f62-9c15306a1421@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/20 22:44, Krish Sadhukhan wrote:
>>>
>>> +    if (valid && (type == SVM_EVTINJ_TYPE_EXEPT))
>>> +        if (vector == NMI_VECTOR || vector > 31)
>> Preferred style is to combine these into a single statement.
> 
> 
> The reason why I split them was to avoid using too many parentheses 
> which was what Paolo was objecting to. 😁

But you kept the parentheses that I was objecting to.  Good:

	if (valid && type == SVM_EVTINJ_TYPE_EXEPT &&
	    (vector == NMI_VECTOR || vector > 31))

Bad:

	if (valid && (type == SVM_EVTINJ_TYPE_EXEPT) &&
	    (vector == NMI_VECTOR || vector > 31))

There should be no parentheses around relational operators, only around 
& | ^ and && ||.

Thanks,

Paolo

