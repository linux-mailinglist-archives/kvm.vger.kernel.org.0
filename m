Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8548631547E
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 17:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhBIQ4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 11:56:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20050 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232814AbhBIQ4d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 11:56:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612889707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I9b1PHDHkx3hhQyiMmZpnuR1MsEFs0dELFK1kzY2RAk=;
        b=hW2v1ZEcwoEeiLieFI18tGOLVtU9fmG+eSOXR8F2x3yzYRUbYIcFQTZzY907ru/BMQyGNp
        gC090j3dCT2ee4uCEmMQO3qPomaIKBnsi5acaFtSHES71too/odhl0KNN6K8lbIx837Y6F
        v/TNrdcmb/6K3QeruxWTqDeEC89R+30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-Sccf_1YAO4S4dEyubqTTYw-1; Tue, 09 Feb 2021 11:55:03 -0500
X-MC-Unique: Sccf_1YAO4S4dEyubqTTYw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 218C685B667;
        Tue,  9 Feb 2021 16:55:02 +0000 (UTC)
Received: from [10.36.113.141] (ovpn-113-141.ams2.redhat.com [10.36.113.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BC6D68D22;
        Tue,  9 Feb 2021 16:55:00 +0000 (UTC)
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        imbrenda@linux.ibm.com
References: <20210209141554.22554-1-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Subject: Re: [kvm-unit-tests PATCH] s390x: Workaround smp stop and store
 status race
Message-ID: <38e70380-f3e4-58b1-6ee8-ea76999f1ed3@redhat.com>
Date:   Tue, 9 Feb 2021 17:55:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210209141554.22554-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.02.21 15:15, Janosch Frank wrote:
> KVM and QEMU handle a SIGP stop and store status in two steps:
> 1) Stop the CPU by injecting a stop request
> 2) Store when the CPU has left SIE because of the stop request
> 
> The problem is that the SIGP order is already considered completed by
> KVM/QEMU when step 1 has been performed and not once both have
> completed. In addition we currently don't implement the busy CC so a

QEMU remembers that stop-and-store-status is active in 
"cpu->env.sigp_order" and rejects other orders until completed with 
SIGP_CC_BUSY. See handle_sigp_single_dst().

The "issue" is that the kernel does not know about that. The kernel will 
continue handling
- SIGP_SENSE
- SIGP_EXTERNAL_CALL
- SIGP_EMERGENCY_SIGNAL
- SIGP_COND_EMERGENCY_SIGNAL
- SIGP_SENSE_RUNNING
itself and not go to user space where that information is present. And 
for some of these orders we really don't want to go to user space.

I remember that at least SIGP_SENSE_RUNNING doesn't give any guarantees, 
so that one might be correct.

I remember that it was a little unclear if all of these orders actually 
have to wait for other orders to finish (IOW: return SIGP_CC_BUSY). 
Especially with SIGPIF even the hardware has no idea if we are emulating 
a SIGP STOP .* right now, how should it know? We would have to disable 
the facility, and that's most probably not what the HW/facility was 
designed for.

Yeah, it's complicated. We would have to let QEMU "set" and "clear" a 
SIGP busy status in the kernel. Then we could at least let SIGP SENSE be 
correct and fast (I think that's the only critical one to get right).

-- 
Thanks,

David / dhildenb

