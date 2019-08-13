Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB1328B3D1
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 11:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbfHMJPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 05:15:53 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39039 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbfHMJPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 05:15:44 -0400
Received: by mail-wr1-f67.google.com with SMTP id t16so16935349wra.6
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 02:15:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q7bgqMdQ4an3+fW9pjXHTss4SNTSFngzufR2wW+436s=;
        b=kUvwMIn+SPVK4JxmzDcSDOsEeNu2Ek8awo8lhN775cQAAmZw1NpCR82rXN8rv57a9W
         0pUh8CCpJ13uW3Zobc5trbgQrk89xwnvJPYNV00FcsaPZ+7XS33PSpeNrlDxcCNZdgh/
         2A26/9+7WzVSWOnQQaa5YTvTBeVtf/siO65PjWZ9iCBSLN08XgKkdlvs5WZo2fX7rMo6
         O5gB9ecKxPBkrxTJk9jJBhdaDiwSfm0MgUC+La6wiuEW2NaEOgxvm+rR5WFTD+8sdNn6
         DnqXfjQKcrBF+jG/LlayRHPtZS+2xrUus0bHJSEC0fl0SMd9eNKegS+NfTRghd6HAIwT
         YQ6w==
X-Gm-Message-State: APjAAAXG/xV1PaepFz1Z2jlbov10u9ovVaaiQCDXsO0Weyfo2MN4M7rq
        tu0kAv3TEEfq7+IxDquDAUivQw==
X-Google-Smtp-Source: APXvYqxstOWD8uGBtXH2sZT96q5cW3boODxMOIYCbZ+H7TsBnLr+a/3ZIecGYglK7JULc1kUyTstKQ==
X-Received: by 2002:adf:dc0f:: with SMTP id t15mr25505581wri.50.1565687742155;
        Tue, 13 Aug 2019 02:15:42 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w5sm914921wmm.43.2019.08.13.02.15.40
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 02:15:41 -0700 (PDT)
Subject: Re: [RFC PATCH v6 06/92] kvm: introspection: add
 KVMI_CONTROL_CMD_RESPONSE
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C Zhang <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-7-alazar@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e8f59b08-734a-2ce1-ae28-3cc9d90c0bcb@redhat.com>
Date:   Tue, 13 Aug 2019 11:15:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809160047.8319-7-alazar@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 17:59, Adalbert Lazăr wrote:
> +If `now` is 1, the command reply is enabled/disabled (according to
> +`enable`) starting with the current command. For example, `enable=0`
> +and `now=1` means that the reply is disabled for this command too,
> +while `enable=0` and `now=0` means that a reply will be send for this
> +command, but not for the next ones (until enabled back with another
> +*KVMI_CONTROL_CMD_RESPONSE*).
> +
> +This command is used by the introspection tool to disable the replies
> +for commands returning an error code only (eg. *KVMI_SET_REGISTERS*)
> +when an error is less likely to happen. For example, the following
> +commands can be used to reply to an event with a single `write()` call:
> +
> +	KVMI_CONTROL_CMD_RESPONSE enable=0 now=1
> +	KVMI_SET_REGISTERS vcpu=N
> +	KVMI_EVENT_REPLY   vcpu=N
> +	KVMI_CONTROL_CMD_RESPONSE enable=1 now=0

I don't understand the usage.  Is there any case where you want now == 1
actually?  Can you just say that KVMI_CONTROL_CMD_RESPONSE never has a
reply, or to make now==enable?

> +	if (err)
> +		kvmi_warn(ikvm, "Error code %d discarded for message id %d\n",
> +			  err, msg->id);
> +

Would it make sense to even close the socket if there is an error?

Paolo
