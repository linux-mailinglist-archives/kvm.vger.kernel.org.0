Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 340B31A104C
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 17:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbgDGPgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 11:36:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25050 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728917AbgDGPgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 11:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586273811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fhk1Rka8q2SudzUU68AfT6FR9kYZE7tza578EHfOEfM=;
        b=PWnSgvpQJ5oUZp2qXqI5PtReaDvivajM2SpEc2rwU32NaLWtw8xBiD+E6/rEmU9cWDMOa6
        PpYWkXD12cOdnS1zk0t0FRi57psFRvvbE+2QBVCOS2ExQ6DoMCojkl4Z3NpcqgzC0TK+BD
        uFj1pjHJDpsDlFCm+s+xxQqs57QXULA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-Ig1jOvQqOba0KN_AtAIKSw-1; Tue, 07 Apr 2020 11:36:50 -0400
X-MC-Unique: Ig1jOvQqOba0KN_AtAIKSw-1
Received: by mail-wr1-f71.google.com with SMTP id m15so2176563wrb.0
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 08:36:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fhk1Rka8q2SudzUU68AfT6FR9kYZE7tza578EHfOEfM=;
        b=uFn8iM/iaL4T3GpMWzsVX60v+mTMBI3DdqqUmpEQuzOKNAN6dsSdhgw6BPU3zGgdta
         3FFgSSlC9sz9IoM2xpFZ0IZuEnXTMTdo/3XiSUIR2EdUa4E76MtgMp3tnupDi/3BYcsI
         +Cs86n5zrj20bLWU+sisCk/xPPgsek3to17gvnaPiwyEsDnFQVEhtZqqQ5QOPDO5Sj6j
         QPOrwyemTA/OQC4bhYeTUbuEe6t1JRQghCx/E5zjAnmSvN4Mc8jUfulMcNHhp+oGL9Nv
         Z9PWD1SYFQHhVQ9vdi7ausTl4Jm4uISiLOxBu3UND/PPY6ZtSww48rqCQTC6kSbUVOcm
         S8mw==
X-Gm-Message-State: AGi0PubaTmEzz5/8B/uSmi8NeEs21fQS2Is4v6+pLiZB66Qvv+wL+c0j
        uFK8PzWY3EYtQywabnP66HYZVXDrLzy4tAJTHLbAMVRxO8jmg5JBqa+xbTShObgXYMNoOXDR+52
        nZO3z9xMdIx3S
X-Received: by 2002:a5d:5586:: with SMTP id i6mr3188382wrv.23.1586273808870;
        Tue, 07 Apr 2020 08:36:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypLx4Lhf/LQOPUh4fKois4WDvTeY4ODg3dPKfdVIOTP2kPcAzkGWhftUJlKen4VRlv9vsLHyvQ==
X-Received: by 2002:a5d:5586:: with SMTP id i6mr3188366wrv.23.1586273808613;
        Tue, 07 Apr 2020 08:36:48 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id d13sm31465498wrv.34.2020.04.07.08.36.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 08:36:48 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 1/2] run_migration: Implement our own wait
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     lvivier@redhat.com, thuth@redhat.com, david@redhat.com,
        frankja@linux.ibm.com
References: <20200404154739.217584-1-drjones@redhat.com>
 <20200404154739.217584-2-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f4b7977e-d04b-a642-2624-dbb4c15cbb2a@redhat.com>
Date:   Tue, 7 Apr 2020 17:36:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200404154739.217584-2-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/04/20 17:47, Andrew Jones wrote:
> Bash 5.0 changed 'wait' with no arguments to also wait for all
> process substitutions. For example, with Bash 4.4 this completes,
> after waiting for the sleep
> 
>   (
>     sleep 1 &
>     wait
>   ) > >(tee /dev/null)
> 
> but with Bash 5.0 it does not. The kvm-unit-tests (overly) complex
> bash scripts have a 'run_migration ... 2> >(tee /dev/stderr)'
> where the '2> >(tee /dev/stderr)' comes from 'run_qemu'. Since
> 'run_migration' calls 'wait' it will never complete with Bash 5.0.
> Resolve by implementing our own wait; just a loop on job count.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  scripts/arch-run.bash | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index d3ca19d49952..da1a9d7871e5 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -156,7 +156,11 @@ run_migration ()
>  	echo > ${fifo}
>  	wait $incoming_pid
>  	ret=$?
> -	wait
> +
> +	while (( $(jobs -r | wc -l) > 0 )); do
> +		sleep 0.5
> +	done
> +
>  	return $ret
>  }
>  
> 

Ouch.  Queued both, thanks.

Paolo

