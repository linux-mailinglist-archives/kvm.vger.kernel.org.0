Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 004048B31D
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 10:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbfHMIza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 04:55:30 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55004 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728376AbfHMIz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 04:55:26 -0400
Received: by mail-wm1-f67.google.com with SMTP id p74so738193wme.4
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 01:55:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sPUyfB4muaIr59fd4usHXqxooogTzwXwDuPC1t7ce04=;
        b=oraCBNTzgxKl8cVAcpHHZmOURipAhUS6g9A9q/lLX0ZnNOr++V0cJCy2CNoOT4HKK9
         ICqd9yhOMICEbGQQMjDuUmUHyIv9TCuTxCQbuKmn6LGy9Qnttk4A/JyU6aPOW3tSfImm
         AqCFJPOP3xTq86snZ0YdqKyyQ/oDdgyOBRf+nde5Jf5KXDDHr0zHIb0znsYsetFZLK+i
         qsLhNh9eQyBLOlYYJCDskvFR3b1EmtWbVce7ntyx6eVSWv3JYohBdYtfikJjWRbPfTG0
         pF7RCM+xwjf41PHndOzipgL0n7dkODUEzKwmFaLW6DOZnpt6yUETTSLqqrJz040+fmuM
         uJjA==
X-Gm-Message-State: APjAAAWJZWxI4rpNps0jurixkkXtRoDxgVOxXHhoYh9oGJEQaEF/xQXQ
        u4nBBTqrRzaeIWhOnr7wtJuRuQ==
X-Google-Smtp-Source: APXvYqxbrJjpte7v8LCdT4TY1BMezIoEu72MDVQxtXaSnj9GyHSbv3Go1giiz3C/PIGfATdRGc3mYg==
X-Received: by 2002:a05:600c:2292:: with SMTP id 18mr1851704wmf.156.1565686524175;
        Tue, 13 Aug 2019 01:55:24 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id n14sm212546507wra.75.2019.08.13.01.55.22
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 01:55:23 -0700 (PDT)
Subject: Re: [RFC PATCH v6 16/92] kvm: introspection: handle events and event
 replies
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C Zhang <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-17-alazar@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <08325b3b-3af9-382b-7c0f-8410e8fcb545@redhat.com>
Date:   Tue, 13 Aug 2019 10:55:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809160047.8319-17-alazar@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 17:59, Adalbert Lazăr wrote:
> 
> +			 reply->padding2);
> +
> +	ivcpu->reply_waiting = false;
> +	return expected->error;
> +}
> +
>  /*

Is this missing a wakeup?

>  
> +static bool need_to_wait(struct kvm_vcpu *vcpu)
> +{
> +	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
> +
> +	return ivcpu->reply_waiting;
> +}
> +

Do you actually need this function?  It seems to me that everywhere you
call it you already have an ivcpu, so you can just access the field.

Also, "reply_waiting" means "there is a reply that is waiting".  What
you mean is "waiting_for_reply".

The overall structure of the jobs code is confusing.  The same function
kvm_run_jobs_and_wait is an infinite loop before and gets a "break"
later.  It is also not clear why kvmi_job_wait is called through a job.
 Can you have instead just kvm_run_jobs in KVM_REQ_INTROSPECTION, and
something like this instead when sending an event:

int kvmi_wait_for_reply(struct kvm_vcpu *vcpu)
{
	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);

	while (ivcpu->waiting_for_reply) {
		kvmi_run_jobs(vcpu);

		err = swait_event_killable(*wq,
				!ivcpu->waiting_for_reply ||
				!list_empty(&ivcpu->job_list));

		if (err)
			return -EINTR;
	}

	return 0;
}

?

Paolo
