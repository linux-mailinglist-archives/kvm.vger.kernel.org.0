Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 715CB30B2B
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 11:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfEaJMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 05:12:25 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55546 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbfEaJMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 05:12:25 -0400
Received: by mail-wm1-f68.google.com with SMTP id 16so1138384wmg.5
        for <kvm@vger.kernel.org>; Fri, 31 May 2019 02:12:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0AxDHUUpSLBZZ6pZG7HK+8YHC3CP8Xm9yOJRwOpXCuQ=;
        b=YZtLk6rNLwvR85bXGmOib5Ro08yD0chm5MHrbROJrdFrTqptPLSaBglS4y1/IOcipJ
         q9sgzETYtiAeenLcbfff1s7TFrTj95twK0zN/8lu/mtiTv+NuEkjdlqBuOeeKxalIv/I
         lSvnxRxlhEMkNHWZmqwpQSN2jEXuQY87/Jv4FeU0Ynp23OSxAUGjlUaacyC4OnJx4TrG
         SeUOS+KkQYQ4CxGZYFzZz1x9sUGIBlGLMSCN5mWIHFLfyPpMMCzRL05AVVXcZY9PlDrG
         vTSVPyr4swxz9RpNpmlNXjZSni1CdkuAhZfesvqOfaIyakuzKIsZOtzI5v8SLaQSHnet
         NGjw==
X-Gm-Message-State: APjAAAUXL+4ZOm+SOe4383oLdchQFgD1u3AzKRWsmlGfEVorZGksp6HX
        uddtYzsjIgQ+fzahGL6GH7mV+w==
X-Google-Smtp-Source: APXvYqyw1+UhzpIse+RJ2T972JNibsmHBYB+uO8y2y3HMDCATkvY2o+jjLDciy4QUoh9kx388sVp1Q==
X-Received: by 2002:a1c:808b:: with SMTP id b133mr4754979wmd.160.1559293942789;
        Fri, 31 May 2019 02:12:22 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id t6sm10181349wmt.34.2019.05.31.02.12.21
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 02:12:21 -0700 (PDT)
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
To:     Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, stefanha@redhat.com
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-2-pbonzini@redhat.com>
 <ad0578b0-ce73-85ed-b67d-70c5d8176a23@acm.org>
 <461fe0cd-c5bc-a612-6013-7c002b92dcdc@redhat.com>
 <740d2f33-004e-7a37-1f6e-cf29480439b1@acm.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dd00ef94-1d28-1401-2375-7603e9543e2d@redhat.com>
Date:   Fri, 31 May 2019 11:12:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <740d2f33-004e-7a37-1f6e-cf29480439b1@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/05/19 19:54, Bart Van Assche wrote:
> As far as I can see the only impact of defining an empty commit_rqs
> callback on the queueing behavior is that blk_mq_make_request() will
> queue requests for multiple hwqs on the plug list instead of requests
> for a single hwq. The plug list is sorted by hwq before it is submitted
> to a block driver. If that helps NVMe performance it should also help
> SCSI performance.

See the comment in blk_mq_make_request(): sorting by hwq helps NVMe
because it uses bd->last, and blk_mq_make_request() uses the presence of
the ->commit_rqs() as a sign that the driver uses bd->last.  The
heuristic basically trades latency (with plugging, the driver rings the
doorbell a bit later) for throughput (ringing the doorbell is slow, so
we want to do it less).  If the driver doesn't use bd->last and the
doorbell is always rung, plugging adds to the latency without the
throughput benefit.

All that the duplicate blk_mq_ops do is letting blk_mq_make_request()
use the same heuristic for SCSI.  This should be beneficial exactly for
the reason that you mention: if the heuristic helps non-SCSI block
driver performance, it should also help performance of SCSI drivers that
have nr_hw_queues > 1 but no commit_rqs (lpfc, qedi, qla2xxx, smartpqi,
storvsc).

Paolo

> How about always setting commit_rqs = scsi_commit_rqs
> in scsi_mq_ops?

