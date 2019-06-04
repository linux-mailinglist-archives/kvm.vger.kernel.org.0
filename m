Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8AAB352C9
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 00:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfFDWkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 18:40:21 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44460 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDWkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 18:40:21 -0400
Received: by mail-pl1-f194.google.com with SMTP id c5so8904776pll.11;
        Tue, 04 Jun 2019 15:40:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1Aw/iJs+AOiEaavB7sKDwC9ReJ1P0mis+S4Hs1ITT4s=;
        b=ocPJNDGSew1IAOKWCKFWr79Te0dbmO0g/k8qf5Q4MoluLA2Hf+06JLCfX/L74pFi9t
         BF+vN5tOnL+0uG48KHjElCC+pKRo9zzoNK5TUSflL7aNiEL3uW1P2/ELcAN3UwDmUMks
         SQwOND4IYQOa5Gf2sqP769bAyycSUQ47rulFIuVNmpWkrBCggQ0mqrpZGzNuveQoIZ4w
         sTvm4g2KvRsY84btLaxNxAjJV5UCOqyBnXXuWDce0/4qrfCwiuF1pACA8eFGChdiabGO
         Ly10i3ez9A5FDnsbQVFzXo75lD5xo85gMCHKRlUbCRCaOrCgb3yYgY+WDtq6/PTi7ZMc
         YuZA==
X-Gm-Message-State: APjAAAWo2BGkuiyKJKIbmfF+VBbdnsXH32L9tlbOnymzsRy4Jh+XNUYU
        7+ex89JbzqSKsVX+fYznsIIldW7x
X-Google-Smtp-Source: APXvYqzrSBsiBoxLDSKZ/Cy5U/3OP8lrINu/hou4BgEFpIUfSzPZtZDQT9mpZvNqAF+EbdOg1gi6wg==
X-Received: by 2002:a17:902:b102:: with SMTP id q2mr29846224plr.149.1559688020767;
        Tue, 04 Jun 2019 15:40:20 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id s1sm15129820pgp.94.2019.06.04.15.40.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 15:40:19 -0700 (PDT)
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, stefanha@redhat.com
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-2-pbonzini@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c175c8ae-2cec-6423-5cda-b1abcc4b42e5@acm.org>
Date:   Tue, 4 Jun 2019 15:40:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190530112811.3066-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/30/19 4:28 AM, Paolo Bonzini wrote:
> This allows a list of requests to be issued, with the LLD only writing
> the hardware doorbell when necessary, after the last request was prepared.
> This is more efficient if we have lists of requests to issue, particularly
> on virtualized hardware, where writing the doorbell is more expensive than
> on real hardware.
> 
> The use case for this is plugged IO, where blk-mq flushes a batch of
> requests all at once.
> 
> The API is the same as for blk-mq, just with blk-mq concepts tweaked to
> fit the SCSI subsystem API: the "last" flag in blk_mq_queue_data becomes
> a flag in scsi_cmnd, while the queue_num in the commit_rqs callback is
> extracted from the hctx and passed as a parameter.
> 
> The only complication is that blk-mq uses different plugging heuristics
> depending on whether commit_rqs is present or not.  So we have two
> different sets of blk_mq_ops and pick one depending on whether the
> scsi_host template uses commit_rqs or not.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
