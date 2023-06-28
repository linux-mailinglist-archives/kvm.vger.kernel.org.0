Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D760574178D
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 19:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbjF1Rxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 13:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbjF1Rxt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 13:53:49 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4181FCB
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 10:53:47 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3fba5a8af2cso2124075e9.3
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 10:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tarent.de; s=google; t=1687974826; x=1690566826;
        h=content-transfer-encoding:mime-version:content-language:references
         :message-id:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rkehA2SMIOQqe9QC8FAirLKEFUSBZAdhGobadbPBD3I=;
        b=mRRzYBp9ozMEIuGKXB9/xSrwx4vZF+U3ldcWRJLrfHSg97L5z0D0JqpFbfzrbWdvWe
         YbSqLMgSbojWzo0OTAgHu7HffhLTI0QvmgsTD0wlhqkA1gE5Fy/kkQ6MHqnFcFanXr86
         1eCi+xRJFJ05T4cHY9sn8PAsTDh5sVtOjZ57k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687974826; x=1690566826;
        h=content-transfer-encoding:mime-version:content-language:references
         :message-id:in-reply-to:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rkehA2SMIOQqe9QC8FAirLKEFUSBZAdhGobadbPBD3I=;
        b=Q1mGxOmFYmg7mZR+y1z9TgIzATI/tvzF0mx7mpNOmDxd28Co1r/xy7evEVLVfoyGuB
         /3vhvd0gTjoIRNbt/EEOUukMaGJ92vp+hVhB7N7QRdIY0nMaZTjJddhKhewIMy83Y51i
         bazEaDIsi0322KYI1afLMUF99EEtWc2oUIZyPrMVo4a0+5BzFkGwK53cMeZ/SuKB48mx
         ClVAdM8UEh+5JudHbp/D+hB86pE5a1Fq94r6hEh7OvBM/XHX+SCCPq9b244xBBPWYCaw
         UNY0FPwkHJ4fBQam8YgU6I1al1FTtEn0S7UJI8RHApDXQnsL5YIcWB4WC6QybK1xWobr
         6Wfw==
X-Gm-Message-State: AC+VfDz/+d7TgS+QSO/+OBoyUnCIffAwO9t/PX7YVvqthz/lGQ2WlleS
        Y0V0IbFf4acBuKGruU6xJeyM/+Gi7W9R7yfrOiSOlA==
X-Google-Smtp-Source: ACHHUZ7wMLCF0vsdYyRq5MRNXfRX44gc1KQILjiQnKa1TB9ulXAgiUzNizWflnT8czi5VEqlTLt76Q==
X-Received: by 2002:a7b:c8c2:0:b0:3f9:5d0:b71d with SMTP id f2-20020a7bc8c2000000b003f905d0b71dmr22762351wml.30.1687974825625;
        Wed, 28 Jun 2023 10:53:45 -0700 (PDT)
Received: from [2001:4dd7:2921:0:21f:3bff:fe0d:cbb1] ([2001:4dd7:2921:0:21f:3bff:fe0d:cbb1])
        by smtp.gmail.com with ESMTPSA id z24-20020a05600c221800b003fa96fe2bd9sm9465143wml.22.2023.06.28.10.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 10:53:45 -0700 (PDT)
Date:   Wed, 28 Jun 2023 19:53:44 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Sean Christopherson <seanjc@google.com>
cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: VMX: Require KVM_SET_TSS_ADDR being called prior
 to running a VCPU
In-Reply-To: <ZJxd8StU25UJKBSk@google.com>
Message-ID: <ed1914ca-bb4d-78e4-8af-432a5829739@tarent.de>
References: <5142D010.7060303@web.de> <f1afa6c0-cde2-ab8b-ea71-bfa62a45b956@tarent.de> <ZJxd8StU25UJKBSk@google.com>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Jun 2023, Sean Christopherson wrote:

>Dropped all the old maintainers from Cc.  This is one of the more impressi=
ve
>displays of thread necromancy I've seen :-)

Well, I found that mail, and it specifically mentioned users not having
reported seeing this message, so=E2=80=A6

>> Full dmesg attached. This is on reboot, no VMs are running yet.
>
>Heh, there are no VMs that _you_ deliberately created, but that doesn't me=
an there
>aren't VMs in the system.  IIRC, libvirt (or maybe systemd?) probes KVM by=
 doing
>modprobe *and* creating a dummy VM.  If whatever is creating a VM also cre=
ates a
>vCPU, then the "soft" warning about KVM_SET_TSS_ADDR will trigger.

No systemd here, but libvirt might be it. There=E2=80=99s significant time =
between
the last kernel messages and this, that would explain it.

>So long as the VMs you care about don't have issues, the message is comple=
tely
>benign, and expected since you are running on Nehalem, which doesn't suppo=
rt
>unrestricted guest.

OK, thanks.

Might want to make that more well-known=E2=80=A6 though I don=E2=80=99t hav=
e a
good idea how. Perhaps the next person to run into that message
will, at least, find this thread.

bye,
//mirabilos
--=20
Infrastrukturexperte =E2=80=A2 tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn =E2=80=A2 http://www.tarent.de/
Telephon +49 228 54881-393 =E2=80=A2 Fax: +49 228 54881-235
HRB AG Bonn 5168 =E2=80=A2 USt-ID (VAT): DE122264941
Gesch=C3=A4ftsf=C3=BChrer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Ale=
xander Steeg

                        ***************************************************=
*
/=E2=81=80\ The UTF-8 Ribbon
=E2=95=B2=C2=A0=E2=95=B1 Campaign against      Mit dem tarent-Newsletter ni=
chts mehr verpassen:
=C2=A0=E2=95=B3=C2=A0 HTML eMail! Also,     https://www.tarent.de/newslette=
r
=E2=95=B1=C2=A0=E2=95=B2 header encryption!
                        ***************************************************=
*
