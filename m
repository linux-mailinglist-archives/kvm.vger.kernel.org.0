Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC1E4F14F9
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 14:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346258AbiDDMic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 08:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239289AbiDDMib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 08:38:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBBA3275C0
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 05:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649075794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ucG7CKhOXQxhd9YVn++2bq+OejY6acD5Dyyxst5dGg=;
        b=V0MFfFlZFhU7OViRG9m/sr+LsF/gjaETcHuFR4Pdoi9jux/MEtI7dlZcLEdlVZSmk14hDT
        31A4EgV+umUj2zv+WbSEeXyqtQ42rLc1uQBXoJjq49dCt+iPxC6ziLg/bybzZs4FVCL/5m
        S3NE3Ys/4qI3kA4KoGacvVzpD+gj3Eo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-thtjbbwsMt-w-P79D7DVKg-1; Mon, 04 Apr 2022 08:36:33 -0400
X-MC-Unique: thtjbbwsMt-w-P79D7DVKg-1
Received: by mail-ed1-f71.google.com with SMTP id l24-20020a056402231800b00410f19a3103so5424908eda.5
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 05:36:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6ucG7CKhOXQxhd9YVn++2bq+OejY6acD5Dyyxst5dGg=;
        b=IB87QaRF7mv0EPlANXqW1OpQFXV0VN2s7l16t5epeZ56iP/c0xAIhk716RoNLfHaqE
         gnimSWTIHd8UOM7romsScr8Ac06FHXHlnyxT7w86eAhgYiDDEHJE69J4VQTb9uTjb9UG
         8oAG2ggC/j5CjdRBVavUOCFsCFsCX7iL830jwTc2M2ED/yGBLBbHDTmgsXx2tLVAX+W3
         kDLUIOgPg4Nsq0llXkIVjzJ69lRBg0SaEsfVptaqrRIvpVmEFXI99mnERLAizX6sF3lx
         mzq3dMJVFE7w/OBXvivzlL0ZrPoKa8in3xQlwWaT3fjaCCHzmVAKQUN46dFzN1yhrB+8
         wtKA==
X-Gm-Message-State: AOAM532y4QR6eow1E2T+fiwuKbO/P2Lg54lgt8KsgY4PvOpPt3Z5/W5Q
        XcsG4BtdfZA4XemTrW4nLRZ8LgnlEzGvKGBDlZ/drTtfb07MV5YB7MO7kaW0Pmb4TSY1wcvC8Al
        N54LIBzP2a2N1
X-Received: by 2002:a17:907:1c0c:b0:6e0:9b15:29d5 with SMTP id nc12-20020a1709071c0c00b006e09b1529d5mr10634350ejc.416.1649075792269;
        Mon, 04 Apr 2022 05:36:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBVgZGAP9kwOrKgPKmdYoXUYdAhAi8KcPiRzFFkpzMWCfiGq0LrsHtUDxUgPiCN3aEpYZIXQ==
X-Received: by 2002:a17:907:1c0c:b0:6e0:9b15:29d5 with SMTP id nc12-20020a1709071c0c00b006e09b1529d5mr10634335ejc.416.1649075792087;
        Mon, 04 Apr 2022 05:36:32 -0700 (PDT)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a5-20020aa7cf05000000b0041919e52a38sm5269738edy.46.2022.04.04.05.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 05:36:31 -0700 (PDT)
Date:   Mon, 4 Apr 2022 14:36:30 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     "Kallol Biswas [C]" <kallol.biswas@nutanix.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>, lersek@redhat.com
Subject: Re: General KVM/QEMU VM debugging techniques
Message-ID: <20220404143630.02992ea4@redhat.com>
In-Reply-To: <SJ0PR02MB8862328DCA089E7B5699B927FEE09@SJ0PR02MB8862.namprd02.prod.outlook.com>
References: <SJ0PR02MB886210F928C7CD01DFAD5FD0FEE09@SJ0PR02MB8862.namprd02.prod.outlook.com>
        <SJ0PR02MB8862328DCA089E7B5699B927FEE09@SJ0PR02MB8862.namprd02.prod.outlook.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 1 Apr 2022 23:50:16 +0000
"Kallol Biswas [C]" <kallol.biswas@nutanix.com> wrote:

> Hi,
> =C2=A0=C2=A0=C2=A0 We are observing a problem with CPU hotplug.
>=20
> If secureboot option is enabled under UEFI =C2=A0and then if we try to do=
 CPU hotplug the VM crashes/just reboots.
>=20
> No crash dump is generated, no panic message, just VM restarts. Issue see=
ms like:=20
> https://bugzilla.redhat.com/show_bug.cgi?id=3D1834250

CPU hotplug with SMM (for q35) was merged in QEMU-5.2
and unplug part in 6.0, you also need a matching OVMF build
to make it work. Later upto 6.2 (included) there were minor
fixes dealing with incorrect configs.

> What are the debugging techniques we can apply to halt the VM and examine=
 what's going on?
> VM has been configured with crash dump.

I'd start with https://www.linux-kvm.org/page/Tracing

to find out when it goes south.

> Nucleodyne at Nutanix
> 408-718-8164
>=20

