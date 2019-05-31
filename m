Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 127AC30B00
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 11:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfEaJDU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 05:03:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33063 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfEaJDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 05:03:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id d9so5997442wrx.0
        for <kvm@vger.kernel.org>; Fri, 31 May 2019 02:03:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HRebP66JW4IyuOF0hDBqAwbwyYWxhmEAnf33J7IdOA0=;
        b=Q8CfAn7DSA5zQwfJ6f+0GDFYxeYG3P1tE9/3BKIutcyDt/FoyG0EExZ0bzEmNP89Lm
         jdNTFZTeaiDOQsx4jQ7XqplxXWpyxOpqouUH/O+OOsRol5XejAExhOaSJKZPyyRysulE
         Y+yhohjDg6gE7GGqiwKbulIqyk1ABLABC0Ew9yVA52JMTFr+AIfA6pIUaTzP64RCJA9b
         Y0GbBKTBAxfbrGjRwCgcO7ooYRO7zy9eEQdwYjQuJT8Ap3eS5fyZUb7OZEAk9d/9BBo4
         mSYJeuD4EvG5uV4xywNGgGcNr5uzitF3c0itDbFtK20n92yBCTrqSC4YnVF1K91HB90N
         li2Q==
X-Gm-Message-State: APjAAAXPwKKNR/0qDRJE1LSimYHGq4OJxUBFe8dbpPwFZJN6v1AmKQKr
        6NX9EWVIOis8/2j6/2YY5dWGyw==
X-Google-Smtp-Source: APXvYqzCgpfqPthhHvp9vkwXGYSCWJ2vPHCJQrPIU+1WZAFnucXSFqdMv5/v5gsJZPaCNRs1GMAPqg==
X-Received: by 2002:adf:f909:: with SMTP id b9mr5874103wrr.119.1559293398234;
        Fri, 31 May 2019 02:03:18 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id t6sm10141754wmt.34.2019.05.31.02.03.17
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 02:03:17 -0700 (PDT)
Subject: Re: [PATCH 2/2] virtio_scsi: implement request batching
To:     Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, stefanha@redhat.com
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-3-pbonzini@redhat.com>
 <79490df1-0145-5b40-027a-7e8fb96854d4@acm.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ff7aaa01-022b-f55a-4bb2-c293cfd86bdd@redhat.com>
Date:   Fri, 31 May 2019 11:03:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <79490df1-0145-5b40-027a-7e8fb96854d4@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/05/19 19:28, Bart Van Assche wrote:
> On 5/30/19 4:28 AM, Paolo Bonzini wrote:
>> @@ -531,7 +547,8 @@ static int virtscsi_queuecommand(struct Scsi_Host
>> *shost,
>>           req_size = sizeof(cmd->req.cmd);
>>       }
>>   -    ret = virtscsi_kick_cmd(req_vq, cmd, req_size,
>> sizeof(cmd->resp.cmd));
>> +    kick = (sc->flags & SCMD_LAST) != 0;
>> +    ret = virtscsi_add_cmd(req_vq, cmd, req_size,
>> sizeof(cmd->resp.cmd), kick);
> 
> Have you considered to have the SCSI core call commit_rqs() if bd->last
> is true? I think that would avoid that we need to introduce the
> SCMD_LAST flag and that would also avoid that every SCSI LLD that
> supports a commit_rqs callback has to introduce code to test the
> SCMD_LAST flag.

That is slightly worse for performance, as it unlocks and re-locks the
spinlock.

Paolo

