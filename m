Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D357A514C20
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 15:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376945AbiD2ODD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 10:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376940AbiD2OBf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 10:01:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80CB9D0AB7
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 06:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651240330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z7yAdUCrz3+5dYbONp1SEfIacy2JTP0wdG6m3C5H/Qc=;
        b=Z5bD2VyfeSdS/rKqNmATSrryDf0H8L5J/FoZjRmgLS0HEzzDHGqnqgTia89Q2cQ3yG3r/a
        wGb74lDE9UjpmTLj7mZ6/cT2g0qRAzsQAy2Q5z0U5MiUfnQIW41oLDcAWTGLqQZVcl5nYD
        x1IT7PUy0BswGvTWFesVOmq+NqDKAAg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-Lyp8MjYbM3etAB042q75lQ-1; Fri, 29 Apr 2022 09:52:08 -0400
X-MC-Unique: Lyp8MjYbM3etAB042q75lQ-1
Received: by mail-ej1-f71.google.com with SMTP id oz9-20020a1709077d8900b006f3d9488090so3041013ejc.6
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 06:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z7yAdUCrz3+5dYbONp1SEfIacy2JTP0wdG6m3C5H/Qc=;
        b=NOFOBm5fBUZBMxRds0MwywBzsQ5vdeyrfSWcZTqiGowgsVN1a/O36QdeoJhjpYl7Bv
         NSE6IvX6XxzKGudHZjqzBFjdyP8qIlP0Fr5soRnCWyc7/ZK2emkATXwrZRUGS2vNvgzq
         Y/s7fOhgGZ5mGvSBB7vE0Uz1W6oolT09k3bkiQ/9SRoUab7bv9KS1des7lTZ0asDfGPX
         PV5bhQ24/Pe8SbY865T9Md0OSP7jI656+DrrbHwrTj5ifgCOcWXHTxkVjM5GrJV+W8r2
         ozPjXEOZUFTAkYCC4YFmc6tK+vLZF0h9zMlSSQbvBum4OxqlnTtG5ByFECFOEixdMODM
         WONw==
X-Gm-Message-State: AOAM530IIPqcfip9SWoekJERFPjr60pR0RhkeI19ncww5Z+pJWZrZAaD
        juFW2DDD5zao7/LGhpsysjmFntTtbpLZrRL3gzhVRfkS1yTGhv1xI7hvzC0C0I9qxXSw22k7l13
        QEtKoNOI/fHGm
X-Received: by 2002:a17:907:7ea9:b0:6f3:de9c:c6fb with SMTP id qb41-20020a1709077ea900b006f3de9cc6fbmr7793990ejc.304.1651240327298;
        Fri, 29 Apr 2022 06:52:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSXo0F7Exss/lylDpZAOA7UHVmHWcGdVTMhJKtTRR6xOlptpLZ9t9BCMS9mrHY58kigon4hg==
X-Received: by 2002:a17:907:7ea9:b0:6f3:de9c:c6fb with SMTP id qb41-20020a1709077ea900b006f3de9cc6fbmr7793983ejc.304.1651240327113;
        Fri, 29 Apr 2022 06:52:07 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id p9-20020a056402074900b0042617ba639dsm2979367edy.39.2022.04.29.06.52.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 06:52:06 -0700 (PDT)
Message-ID: <ed92111b-3b80-0cde-1821-0a491dee2dcf@redhat.com>
Date:   Fri, 29 Apr 2022 15:52:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH for-5.18] KVM: fix bad user ABI for KVM_EXIT_SYSTEM_EVENT
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20220422103013.34832-1-pbonzini@redhat.com>
 <Ymtr2mfyujoxLsDR@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ymtr2mfyujoxLsDR@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 06:38, Oliver Upton wrote:
>> +                        __u64 data[16];
> This is out of sync with the union { flags; data; } now.

Yes, that's intentional.  The flags member is mentioned below:

+Previous versions of Linux defined a `flags` member in this struct.  The
+field is now aliased to `data[0]`.  Userspace can assume that it is only
+written if ndata is greater than 0.

but I don't want projects to believe it is different in any way from
`data[0]`.  In particular, `flags` should also be considered valid only
if the cap is present (unless crosvm wants ARM to be grandfathered in).

> IMO, we should put a giant disclaimer on all of this to*not*  use the
> flags field and instead only use data. I imagine we wont want to persist
> the union forever as it is quite ugly, but necessary.


>> +/* #define KVM_CAP_VM_TSC_CONTROL 214 */
> 
> This sticks out a bit. Couldn't the VM TSC control patch just use a
> different number? It seems that there will be a conflict anyway, if only to
> delete this comment.

I don't want to change cap numbers once things have landed in
kvm/next, because that's when userspace projects pick them.

Paolo

