Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948B41CA4CA
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 09:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgEHHID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 03:08:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45929 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726048AbgEHHIC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 03:08:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588921682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lHnj9WRBjx7ppoSr03uvcw49ArXRGOCQaERS8s9l65Q=;
        b=EUFfUwCOrIyf7DzhwHMIwDlO7SQLopL2HLdpK8RR2IMHwglDdfAn6bPmCsKVZrgVRAr6k1
        ald78IHuajm7/fnECFDpic78nsCKTBsRWLvpCAQ+ir//hfrmK3jYZrT8Tl6lhRu+7aJqKM
        JsVxwYhjMy6QafCkqR/B9WiTP7IS4mo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-nvagUmWfOdCxHhpz_JbSiQ-1; Fri, 08 May 2020 03:08:00 -0400
X-MC-Unique: nvagUmWfOdCxHhpz_JbSiQ-1
Received: by mail-wm1-f69.google.com with SMTP id w2so4763293wmc.3
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 00:08:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lHnj9WRBjx7ppoSr03uvcw49ArXRGOCQaERS8s9l65Q=;
        b=kusdwk2DX0NFuq/rqW3FrspU9oXnJF8ZDO/tNhaT8NpDNc6iqlG+pE59YzUs8plsxV
         Ueorr4ShaHvONMS0TEQBLZBxHXNSkarUeW3/JS9Hk8qngUayF7XMD2O5t5Owg0rXiJbz
         DTG8S6q0kFoAjPMAPDUJAjSTiqcyXH2r+BH5VBEpSkDX4H89ZChUAJtlmu5CTrSYlCz/
         WFqddnEvs8n9vmzZQISCh53/H8YjY2XJm37KlAOjIVOjnppgCI5AuvJYTFkrpHQcS4Sr
         ejIBaEXGUWPRWHEZVRMtRfhaG8W/k+sCAETJGl+a3Sze2bYtLYG8NVFkeqmRiq27SdDH
         3gwQ==
X-Gm-Message-State: AGi0Pua1/E0sXY7Fkbc/Dw7ULsGev2FJyGjFwKvvkGsofPeTP1n00jVd
        xepxQq33lOaS0bdXBsFts443BZn7m9IiUEQXoUNojDBJpUVZfralJX+c1jGAT2MsIxUqwxqmxYo
        hJNUKpHKgZ6vm
X-Received: by 2002:a5d:56c6:: with SMTP id m6mr1205314wrw.78.1588921679004;
        Fri, 08 May 2020 00:07:59 -0700 (PDT)
X-Google-Smtp-Source: APiQypKbvw584wBobmGmrsSvClZ4jCQneVNDs788BL9GaNepq4eChXCDnTkKuwCW4c6rjh5aKJPafg==
X-Received: by 2002:a5d:56c6:: with SMTP id m6mr1205295wrw.78.1588921678721;
        Fri, 08 May 2020 00:07:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:20ea:bae4:47a7:31db? ([2001:b07:6468:f312:20ea:bae4:47a7:31db])
        by smtp.gmail.com with ESMTPSA id q184sm11690939wma.25.2020.05.08.00.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 00:07:58 -0700 (PDT)
Subject: Re: [PATCH] KVM: No need to retry for hva_to_pfn_remapped()
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200416155906.267462-1-peterx@redhat.com>
 <dba4f310-5838-cd78-73c9-3db84f93766a@redhat.com>
 <20200508022514.GU228260@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4a1221bb-de98-2758-89a0-97aceae8df71@redhat.com>
Date:   Fri, 8 May 2020 09:07:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200508022514.GU228260@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/20 04:25, Peter Xu wrote:
>> Queued, thanks.
> 
> Paolo, Is it still possible to unqueue this patch?  I overlooked the fact that
> if unlocked==true then the vma pointer could be invalidated, so the 2nd
> follow_pfn() is potentially racy.  Sorry for the trouble!
> 

Sure, thanks.

Paolo

