Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9105166888
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 21:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbgBTUhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 15:37:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39638 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729167AbgBTUhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 15:37:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582231029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=so8lauUUoGRoi/jJSytdd24qTKrEHkl0ntF8odMqIEk=;
        b=akBJbxTFsfo8I2lKzku7CuIYQ1nlfvq+XGOLTD+0bN/7evCPez8+iDn9PyfeNABUruU+JU
        rWEKXK4QMwJGu2A7k6nZDnuiRn9qDruxj9GNBsmnnlmZ/6fSmCqexUhqlQblvl6kY27LI3
        GKIX6c1Y3ajWH0MEgl7KbgL++aoqIWM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-X-SKhq6sNe--D-e1Tugkyw-1; Thu, 20 Feb 2020 15:37:06 -0500
X-MC-Unique: X-SKhq6sNe--D-e1Tugkyw-1
Received: by mail-qv1-f69.google.com with SMTP id c1so3413943qvw.17
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 12:37:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=so8lauUUoGRoi/jJSytdd24qTKrEHkl0ntF8odMqIEk=;
        b=loAvqJ9YkOfOvk7Khq7gREU8XyhQVJmwwaLYI6fSMQ7iMHqT03mhVtpOOuPi5sZg38
         3lfmChWqE8ujJPp+epARWkeaFvgRi6JS28KMLGS+fNjYHRsD+xFU2HbOqKv5CZKCbkYp
         gyHxof8gDt6kBERRypU1WI3MblrHew3LzZofnjRvJkgn4XKRzqyfsJCp927IKKs5J4VT
         IoifOJdGJYTmFWTdyqa2w/TWmlahK/KL7blEcIUxl81d0D6i90/twvnph2LNcghH4ZF+
         k8CfZGo1RpHy4UVYRCRj48B7Y/LnNNfFtaBSjXQ68D6CjFkkhXTABQLdU6EHRgNfHCN/
         GCVw==
X-Gm-Message-State: APjAAAVxTw+mWTSTq0SML1qJi0AWcwnJ5e5zlgdMRxo/HbaIaj9ZabCc
        rtDj6jUHi4PcXy/dGg01nhkLod8m5hldGzGUrT5R7UXBWm8os/yVVOvwJwb/BuFbRDhK5ViwMV4
        qa6M0g97UqO4R
X-Received: by 2002:a05:6214:1708:: with SMTP id db8mr26944590qvb.129.1582231025547;
        Thu, 20 Feb 2020 12:37:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqz2CDQ9YV75e83hj4oP1c/1mOoRGzxY5Z43juejD8dEw+xmm2eKkwPF3YfbhM2cUNmFM6trdQ==
X-Received: by 2002:a05:6214:1708:: with SMTP id db8mr26944566qvb.129.1582231025364;
        Thu, 20 Feb 2020 12:37:05 -0800 (PST)
Received: from redhat.com (bzq-109-67-14-209.red.bezeqint.net. [109.67.14.209])
        by smtp.gmail.com with ESMTPSA id a2sm397978qka.75.2020.02.20.12.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 12:37:04 -0800 (PST)
Date:   Thu, 20 Feb 2020 15:36:53 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Fam Zheng <fam@euphon.net>,
        =?iso-8859-1?Q?Herv=E9?= Poussineau <hpoussin@reactos.org>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Stefan Weil <sw@weilnetz.de>,
        Eric Auger <eric.auger@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Walle <michael@walle.cc>, qemu-ppc@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Alistair Francis <alistair@alistair23.me>,
        qemu-block@nongnu.org,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        Jason Wang <jasowang@redhat.com>,
        xen-devel@lists.xenproject.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mitsyanko <i.mitsyanko@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Richard Henderson <rth@twiddle.net>,
        John Snow <jsnow@redhat.com>
Subject: Re: [PATCH v3 01/20] scripts/git.orderfile: Display Cocci scripts
 before code modifications
Message-ID: <20200220153648-mutt-send-email-mst@kernel.org>
References: <20200220130548.29974-1-philmd@redhat.com>
 <20200220130548.29974-2-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200220130548.29974-2-philmd@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 20, 2020 at 02:05:29PM +0100, Philippe Mathieu-Daudé wrote:
> When we use a Coccinelle semantic script to do automatic
> code modifications, it makes sense to look at the semantic
> patch first.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>

Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  scripts/git.orderfile | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/scripts/git.orderfile b/scripts/git.orderfile
> index 1f747b583a..7cf22e0bf5 100644
> --- a/scripts/git.orderfile
> +++ b/scripts/git.orderfile
> @@ -22,6 +22,9 @@ Makefile*
>  qapi/*.json
>  qga/*.json
>  
> +# semantic patches
> +*.cocci
> +
>  # headers
>  *.h
>  
> -- 
> 2.21.1

