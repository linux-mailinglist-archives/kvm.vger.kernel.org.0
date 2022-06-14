Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD7E54B760
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 19:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242998AbiFNRJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 13:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243674AbiFNRJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 13:09:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72091201A4
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 10:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655226547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TtO7y3+ijZ6YgcAc4PQtJVzw8h5/IO41lJW3F/O5h8o=;
        b=dEeSXGr3F4xyw5pxf8wuE8MktMdUQu1eFLQmbCgnueDKBjS+AKLAAwKN68u6HzWNdawlJ+
        v6F6AftpdZfGsQEmNgUr0MX96aaTtU5borSfG5Pevo1SGMW37CHTkvqm3/rigDldPq6SQm
        DCROFmnLr/8dmT4VwGZvUK/c1STI3Go=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-PX590xngP3SaqljB0n74gQ-1; Tue, 14 Jun 2022 13:09:04 -0400
X-MC-Unique: PX590xngP3SaqljB0n74gQ-1
Received: by mail-wm1-f69.google.com with SMTP id v125-20020a1cac83000000b0039c832fbd02so4414180wme.4
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 10:09:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TtO7y3+ijZ6YgcAc4PQtJVzw8h5/IO41lJW3F/O5h8o=;
        b=1aCuVf+w+bVorjBaD+x+wrx0hqr9G4H6QMETmQdbI4Ne6hc5IaB55SbLArCaB3Zsv6
         H9cmaWgvlPW7CRE6tFwEmCyt1ajRfW6rHhzdIKru8NIbziAVkDgE5i4er7iKUjTqlwVZ
         XiX6LeqELpX2yXJJwYlqDRXssXvpPSvroCrbkrGfPTcirrKvf1w6oevYuciugBtVabjf
         xUMeJ5eRQyJwQrqlLT5FSbA27vmHXmlylELiZXDwGM8bBigG9Zsq3IEvMMo3clr7y5Y8
         nX8xzDiJ+vREWbFay/XhntcVaGSqng38t0S5wepZxAe8tND6AeyOt8z/MQUJauEzv7mK
         8odA==
X-Gm-Message-State: AOAM531ZBh8DV0i2Dasy3/NeNyOngOs0Gx342c6f5WWAllFebgi9+FFb
        G7BebKw+TxP6dXzcSnmKtPB3D1Gs5TJZtd3ewwG6TbFD9e3Imw6MUIkzmjhPuJ7qOWzIILV94xm
        d/ZBO2h1zAwxc
X-Received: by 2002:a1c:f213:0:b0:39b:ad32:5e51 with SMTP id s19-20020a1cf213000000b0039bad325e51mr5215046wmc.72.1655226543168;
        Tue, 14 Jun 2022 10:09:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEH0VwSnOcNDbF6N4JmvvUE3uFVg/Be8POxZzNI8KiXy7aOZbLTS8Lt1QSrzLFl377ZtNdew==
X-Received: by 2002:a1c:f213:0:b0:39b:ad32:5e51 with SMTP id s19-20020a1cf213000000b0039bad325e51mr5215014wmc.72.1655226542875;
        Tue, 14 Jun 2022 10:09:02 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id v1-20020adfebc1000000b0020d07d90b71sm12236421wrn.66.2022.06.14.10.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 10:09:01 -0700 (PDT)
Message-ID: <6dca9fc3-d50a-2920-b22e-73f0bd2c93f9@redhat.com>
Date:   Tue, 14 Jun 2022 19:09:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] KVM: s390: selftests: Fix memop extension capability
 check
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, thuth@redhat.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     david@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-s390@vger.kernel.org, shuah@kernel.org
References: <36d83871-343d-e8a0-1aed-05bf386f9b1b@redhat.com>
 <20220614162635.3445019-1-scgl@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220614162635.3445019-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/14/22 18:26, Janis Schoetterl-Glausch wrote:
> Fix the inverted logic of the memop extension capability check.
> 
> Fixes: 97da92c0ff92 ("KVM: s390: selftests: Use TAP interface in the memop test")
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
> 
> 
> Here you go.
> Hope it doesn't get lost as a reply, but I can always resend
> and it's not super critical after all.
> 
> 
>   tools/testing/selftests/kvm/s390x/memop.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
> index e704c6fa5758..e1056f20dfa1 100644
> --- a/tools/testing/selftests/kvm/s390x/memop.c
> +++ b/tools/testing/selftests/kvm/s390x/memop.c
> @@ -769,7 +769,7 @@ int main(int argc, char *argv[])
>   	ksft_set_plan(ARRAY_SIZE(testlist));
>   
>   	for (idx = 0; idx < ARRAY_SIZE(testlist); idx++) {
> -		if (testlist[idx].extension >= extension_cap) {
> +		if (extension_cap >= testlist[idx].extension) {
>   			testlist[idx].test();
>   			ksft_test_result_pass("%s\n", testlist[idx].name);
>   		} else {

Done, thanks!

Paolo

