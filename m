Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B8A4BA562
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 17:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242918AbiBQQGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 11:06:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236186AbiBQQGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 11:06:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C853C29C123
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 08:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645113949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q8C5mBTF/zQPiu7mRTQ0V1X+3+5OQ4DWAsdzOSei6/I=;
        b=aGz2r9CCvL3gZau+oayAHsiZRDKFYl+/YH2rMg8Af1bYpwO+pGw5HG0+aoUkzh7CPERB+L
        okQVUHw8A8ynOUC/zj2yk2GU/lX5a73K4hWAB0/tD13Y/7NYKzHRgOgr47l8sAf2/gUPxg
        Y2jkWKsLnjc61e+stCJWWumlZoVpdpk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-IH-zet-PPmyFWJ1sapNwrQ-1; Thu, 17 Feb 2022 11:05:48 -0500
X-MC-Unique: IH-zet-PPmyFWJ1sapNwrQ-1
Received: by mail-wr1-f70.google.com with SMTP id s22-20020adf9796000000b001e7e75ab581so2447425wrb.23
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 08:05:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q8C5mBTF/zQPiu7mRTQ0V1X+3+5OQ4DWAsdzOSei6/I=;
        b=wFUNV8C9JgIxIhT9bvSJM9cSxxosyYIFnkLrzjQmpiWtTZG5fC/dw9FU54K0ahh/1V
         F3LrTE85FUS81AqGgDgymRTseH2uV0JoffWY1fMSSacqz+K0RD7jCPJYIh0H3xe+YX/D
         Pl0aBF+m9rHCXp1uwlk1BtrswNE6z/AAWRKDEdF2VGaMzua27OFLitwmNyXbHZgRm/eW
         eHvVFpzMqe8cmVy9bFu2VXEXu380h4wdbv92WgPEhNMrsQc1uS6WACAvRjaWtA37Wnpt
         vIJZkBOEF1PCvs8Ke6A4aX8187CACmxsScegr7o9ZDzbtSbgzEqAHBAs/SjSODPWynlO
         qRdg==
X-Gm-Message-State: AOAM532txwZk9YCpIVNi0hOgDCPwiqCfTjA6eCZuwstEtrAjOUX9HKTm
        0C8uF2HmxHWsdejucPKzM9xZgzn65BCnUok1eFuUVsMgepAQBqupxE9tgakYgIgZJDYjNhUpGz6
        Hwd8SZ7/+mTnR
X-Received: by 2002:adf:e78a:0:b0:1e6:3524:e135 with SMTP id n10-20020adfe78a000000b001e63524e135mr2961068wrm.601.1645113947653;
        Thu, 17 Feb 2022 08:05:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzVqs24c8i2D8Lt4f9Z4iNheHvxgXvMVn69Wevb7xDbVFxS55ujEEr2K1D18VYZWPyWeX53MQ==
X-Received: by 2002:adf:e78a:0:b0:1e6:3524:e135 with SMTP id n10-20020adfe78a000000b001e63524e135mr2961045wrm.601.1645113947428;
        Thu, 17 Feb 2022 08:05:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id c17sm1579430wmh.31.2022.02.17.08.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 08:05:46 -0800 (PST)
Message-ID: <3113f00a-e910-2dfb-479f-268566445630@redhat.com>
Date:   Thu, 17 Feb 2022 17:05:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] KVM: Move VM's worker kthreads back to the original
 cgroup before exiting.
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>,
        Vipin Sharma <vipinsh@google.com>, seanjc@google.com
Cc:     kbuild-all@lists.01.org, mkoutny@suse.com, tj@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, dmatlack@google.com,
        jiangshanlai@gmail.com, kvm@vger.kernel.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220217061616.3303271-1-vipinsh@google.com>
 <202202172046.GuW8pHQc-lkp@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <202202172046.GuW8pHQc-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/22 13:34, kernel test robot wrote:
>> 5859		reattach_err = cgroup_attach_task_all(current->real_parent, current);

This needs to be within rcu_dereference().

Paolo

>    5860		if (reattach_err) {
>    5861			kvm_err("%s: cgroup_attach_task_all failed on reattach with err %d\n",
>    5862				__func__, reattach_err);
>    5863		}
>    5864		return err;
>    5865	}
>    5866	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

