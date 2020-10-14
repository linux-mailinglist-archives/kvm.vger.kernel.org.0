Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B386328E3A5
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 17:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgJNPzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 11:55:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726201AbgJNPzG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Oct 2020 11:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602690905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hLqJDJdyxTbdNV3MGeKQzrWKHd/lx7xzwUHDBNW9Hh8=;
        b=INd9KBnwTKZCPb/KlnTJYc64x+WaQ6N5ognk8aes/k3gr7kOe9G229FW0eVIevO9zt0xnG
        1lNDsdMVLAzTdbLcrR/F8dH0veHU2i696ePENe6NNOI5aM8qMvPASKysKdZbWqUaeu/1eI
        ziTciu3tShS/We+YCh3MHWkxeC/jVUk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-qCUcEiqmN52xruRU7bSCoQ-1; Wed, 14 Oct 2020 11:54:22 -0400
X-MC-Unique: qCUcEiqmN52xruRU7bSCoQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A2E81006704
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 15:54:21 +0000 (UTC)
Received: from thuth.remote.csb (dhcp-192-238.str.redhat.com [10.33.192.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41AC05C1BD;
        Wed, 14 Oct 2020 15:54:20 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] runtime.bash: skip test when checked file
 doesn't exist
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>
References: <20201014154258.2437510-1-vkuznets@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <849201e6-2c21-154d-cb5c-712bd9c3d3b4@redhat.com>
Date:   Wed, 14 Oct 2020 17:54:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20201014154258.2437510-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/2020 17.42, Vitaly Kuznetsov wrote:
> Currently, we have the following check condition in x86/unittests.cfg:
> 
> check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
> 
> the check, however, passes successfully on AMD because the checked file
> is just missing. This doesn't sound right, reverse the check: fail
> if the content of the file doesn't match the expectation or if the
> file is not there.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  scripts/runtime.bash | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 3121c1ffdae8..f94c094de03b 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -118,7 +118,10 @@ function run()
>      for check_param in "${check[@]}"; do
>          path=${check_param%%=*}
>          value=${check_param#*=}
> -        if [ -f "$path" ] && [ "$(cat $path)" != "$value" ]; then
> +	if [ -z "$path" ]; then
> +            continue
> +	fi

That runtime.bash script seems to use spaces for indentation, not tabs ...
so could you please use spaces for your patch, too?

 Thanks,
  Thomas

