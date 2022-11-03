Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF2B617378
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 01:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiKCArA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 20:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiKCAq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 20:46:57 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0DA1260E
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 17:46:56 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l6so203285pjj.0
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 17:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gSW7LRqK56moD2FFcsFTSTTvdHeo5QNysZF8BKf+HCA=;
        b=nP9L5Nw0BZ7iADm7VwDfmZUCJpcu8e9eKi7u2V8bGi4bRTElhaeUO1HRMYbFxvw5y7
         mjtwueTPEMwIo6LIRICkYnKi3Bfr5NoRYpczcR8fVO1/JYu5IESum0r9MElbmcl0XZ99
         yE+NbW3RmbbBgOE8WLsDqmtw0WfJpEBGxoTYacgvwMAGRPQYxv9WkQHWxy7KbwTnuumG
         t0Z9XDYTuuUdnxu+vXzFgiXVd+y6bOkdysh4Gn5hCLe0EoMc/uyi/5jpMUff5atlvbIz
         PDU2g58YaUxNMoHQ5WawkUyDBqk0XmzobQ9xpkWmg2rUsiDZ/NbUWZGfVgUfRxgNYdKk
         GAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSW7LRqK56moD2FFcsFTSTTvdHeo5QNysZF8BKf+HCA=;
        b=06OQOZP7EO8XAYiRUvXUALT9LSfHHb/NWCutZXIgJdNcTMIul+KqypZIj6aZaarihG
         uCFYYk2DCL1ZEPqoX1ZVaRz9xQQyJcGxcP0AoBgMh16mEX28magOh8+VAgypEHshHziH
         cZbhUgxa6aTSPde2XB0u8OWIgVa0gSFSNIdc7rWE2oUq0Un+mYWb9nnXr17RB4JSpK7H
         tS/fx1CaEi5e51pHL1KCn3COc+BwGP6D+uCckCY8DlTWAOq8eE5A1XQIvAz6IPVFh+r/
         zB0iRKg+YWnY9IPmki7Td2Icn01JJblNTdyJWRM/VG2XyRlPEjMyNUBt5JHBMmmQ+PJU
         LnwA==
X-Gm-Message-State: ACrzQf1yvWxTjnJWBOtD3+wM3VXDSlDWZ83W1YHxRZ6iHZg52jQW4F8F
        pFnMOmdE9Fluz+trzUwkBuOM4Y0O4gAH4g==
X-Google-Smtp-Source: AMsMyM6wlcHehaHY09MRiFGVfLaN0xQXejx2nb7gpnkQDHEp0qoZapTRKBFox+oEjo/ngf8A1l5xrA==
X-Received: by 2002:a17:902:b284:b0:187:a99:8178 with SMTP id u4-20020a170902b28400b001870a998178mr25107564plr.98.1667436415550;
        Wed, 02 Nov 2022 17:46:55 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n16-20020a635910000000b0046f6d7dcd1dsm8127430pgb.25.2022.11.02.17.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 17:46:55 -0700 (PDT)
Date:   Thu, 3 Nov 2022 00:46:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, gshan@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 1/1] KVM: selftests: rseq_test: use vdso_getcpu() instead
 of syscall()
Message-ID: <Y2MPe3qhgQG0euE0@google.com>
References: <20221102020128.3030511-1-robert.hu@linux.intel.com>
 <20221102020128.3030511-2-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102020128.3030511-2-robert.hu@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022, Robert Hoo wrote:
> vDSO getcpu() has been in Kernel since 2.6.19, which we can assume
> generally available.
> Use vDSO getcpu() to reduce the overhead, so that vcpu thread stalls less
> therefore can have more odds to hit the race condition.
> 
> Fixes: 0fcc102923de ("KVM: selftests: Use getcpu() instead of sched_getcpu() in rseq_test")
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> ---

...

> @@ -253,7 +269,7 @@ int main(int argc, char *argv[])
>  			 * across the seq_cnt reads.
>  			 */
>  			smp_rmb();
> -			sys_getcpu(&cpu);
> +			vdso_getcpu(&cpu, NULL, NULL);
>  			rseq_cpu = rseq_current_cpu_raw();
>  			smp_rmb();
>  		} while (snapshot != atomic_read(&seq_cnt));

Something seems off here.  Half of the iterations in the migration thread have a
delay of 5+us, which should be more than enough time to complete a few getcpu()
syscalls to stabilize the CPU.

Has anyone tried to figure out why the vCPU thread is apparently running slow?
E.g. is KVM_RUN itself taking a long time, is the task not getting scheduled in,
etc...  I can see how using vDSO would make the vCPU more efficient, but I'm
curious as to why that's a problem in the first place.

Anyways, assuming there's no underlying problem that can be solved, the easier
solution is to just bump the delay in the migration thread.  As per its gigantic
comment, the original bug reproduced with up to 500us delays, so bumping the min
delay to e.g. 5us is acceptable.  If that doesn't guarantee the vCPU meets its
quota, then something else is definitely going on.
