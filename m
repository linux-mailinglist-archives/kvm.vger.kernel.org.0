Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F5F209F10
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 15:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404834AbgFYNBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 09:01:48 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54120 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404709AbgFYNBr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 09:01:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593090106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jExNRMp55CBcYWqWxNtFmp58bp9Mx/2CR39nOQBFaFA=;
        b=JTjQC1d4YWtYGvscl+M+uO5oU8xbNznyto8pknGfkBdkx3Nzfmf/f9HHbqkWCkct0aYqOe
        jf3NMG/5TTbRsy5ZM0HkDg3TI9AY6K1+HaRLvJ9N430fnJC5riycocI0lwmrEjg17qrGXw
        6aYRBD6AlmPw84VNU9k3G/WzJb9HN+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-_2kG6wJdPqakioWgNL6kaA-1; Thu, 25 Jun 2020 09:01:44 -0400
X-MC-Unique: _2kG6wJdPqakioWgNL6kaA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 705DE1083E87;
        Thu, 25 Jun 2020 13:01:42 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-150.ams2.redhat.com [10.36.112.150])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 42C067CAA3;
        Thu, 25 Jun 2020 13:01:40 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] x86: fix stack pointer after call
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     namit@vmware.com
References: <20200625111526.1620-1-pbonzini@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <ae3f91d8-9e6a-c90d-0fca-5e4df2833a0c@redhat.com>
Date:   Thu, 25 Jun 2020 15:01:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200625111526.1620-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/2020 13.15, Paolo Bonzini wrote:
> Since setup_multiboot has a C calling convention, the stack pointer must
> be adjusted after the call.  Without this change, the bottom of the
> percpu area would be 4 bytes below the bottom of the stack.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   x86/cstart.S | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/x86/cstart.S b/x86/cstart.S
> index deb08b7..409cb00 100644
> --- a/x86/cstart.S
> +++ b/x86/cstart.S
> @@ -116,6 +116,7 @@ start:
>   
>           push %ebx
>           call setup_multiboot
> +        addl $4, %esp
>           call setup_libcflat
>           mov mb_cmdline(%ebx), %eax
>           mov %eax, __args

Looks right.

Reviewed-by: Thomas Huth <thuth@redhat.com>

