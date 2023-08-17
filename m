Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD43B77FB45
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 17:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346695AbjHQPx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 11:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353348AbjHQPw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 11:52:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776B230D4
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 08:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692287527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cb3vOuQ+kH0/pSZM4Qtlmw5+LiUYQstAOby+SW+Bxfk=;
        b=YRtM/J8MCgQoRmUnl5T0pMh6jKmzY7Om5YOA5uBfAid009DRfgqymi0ham0ptvHrYSUqz5
        fl8xpDaqyuOlVEX7YZxuj7ptfOg9yCbjjT1x3mVNPKj5dwArT+z+fXIqLQbwzgMThayb9i
        2erQh+FZoyFbTMLDahoV7EEMRwHuWJg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-u16PHGCaNO67dZe8-NzL-g-1; Thu, 17 Aug 2023 11:52:05 -0400
X-MC-Unique: u16PHGCaNO67dZe8-NzL-g-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-99bd6ea0d9eso504274466b.3
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 08:52:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692287524; x=1692892324;
        h=content-transfer-encoding:mime-version:user-agent:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cb3vOuQ+kH0/pSZM4Qtlmw5+LiUYQstAOby+SW+Bxfk=;
        b=VfTDNenOT3V9EW11GxAnPi8zDOnWBYm8TcORkXIE0K/K3RIeFdRX3pghNy/jBE0yYR
         L2SFvPNkIjGOJwy8wdv0Z+yxXUoT65S1rO1wGJI2rImxWX2agQ+gjHqa84CdDqTKRV2p
         An+9dgST72uB6gGiPCJSqx3H8l1Brgh09+40K8CfWUHbb/cKdQhbOQH9/ihR9/AVMHNV
         ToQjcAVJkThKDPcX6upwIjosZa76nOEh7gSQDEXTx7xvqBjgZINNSOfytlRyOqJ4GRt9
         yht67drrj+mBOgOgniIuJVQB0+UCErc75hOi0xq0B1IavgK+QeRVImNUstgsyg+NsegS
         OAXw==
X-Gm-Message-State: AOJu0YzNq2oH9h2GVnsxtR+KOpAaIPi96cIIbQKR4CANL4hg7HmfyH4T
        NeApsm7IgtVRDL2yjZkUwMhwoIjqaL7JyIEl3g986hFeUiL86HoAtSyY9yAZcGxSejMEjuT5YUg
        +sJ9OSUNHGuRH
X-Received: by 2002:a17:907:78d6:b0:994:580c:5049 with SMTP id kv22-20020a17090778d600b00994580c5049mr3921260ejc.5.1692287524483;
        Thu, 17 Aug 2023 08:52:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEYSuhHshTbCW1nXq3/UGD+eEan0fWSN3Vav9nH3UaSvKfRR7o325QMlMkQgHjS9vknG90yw==
X-Received: by 2002:a17:907:78d6:b0:994:580c:5049 with SMTP id kv22-20020a17090778d600b00994580c5049mr3921251ejc.5.1692287524165;
        Thu, 17 Aug 2023 08:52:04 -0700 (PDT)
Received: from starship ([77.137.131.138])
        by smtp.gmail.com with ESMTPSA id l18-20020a1709065a9200b00991e2b5a27dsm10312068ejq.37.2023.08.17.08.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 08:52:03 -0700 (PDT)
Message-ID: <2d47431decaaf4bba0023c91ef0d7fd51b84333b.camel@redhat.com>
Subject: Commit 'sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage'
 broke O_DIRECT over NFS
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-nfs@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Thu, 17 Aug 2023 18:52:01 +0300
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!

I just updated my developement systems to 6.5-rc6 (from 6.4) and now I can't start a VM 
with a disk which is mounted over the NFS.

The VM has two qcow2 files, one depends on another and qemu opens both.

This is the command line of qemu:

-drive if=none,id=os_image,file=./disk_s1.qcow2,aio=native,discard=unmap,cache=none

The disk_s1.qcow2 depends on disk_s0.qcow2

However this is what I get:

qemu-system-x86_64: -drive if=none,id=os_image,file=./disk_s1.qcow2,aio=native,discard=unmap,cache=none: Could not open backing file: Could not open './QFI?': No such file or directory

'QFI?' is qcow2 file signature, which signals that there might be some nasty corruption happening.

The program was supposed to read a field inside the disk_s1.qcow2 file which should read 'disk_s0.qcow2' 
but instead it seems to read the first 4 bytes of the file.


Bisect leads to the above commit. Reverting it was not possible due to many changes.

Both the client and the server were tested with the 6.5-rc6 kernel, but once rebooting the server into
the 6.4, the bug disappeared, thus I did a bisect on the server.

When I tested a version before the offending commit on the server, the 6.5-rc6 client was able to work with it,
which increases the chances that the bug is in nfsd.

Switching qemu to use write back paging also helps (aio=threads,discard=unmap,cache=writeback)
The client and the server (both 6.5-rc6) work with this configuration.

Running the VM on the same machine (also 6.5-rc6) where the VM disk is located (thus avoiding NFS) works as well.

I tested several VMs that I have, all are affected in the same way.

I run somewhat outdated qemu, but running the latest qemu doesn't make a difference.

I use nfs4.

I can test patches and provide more info if needed.

Best regards,
	Maxim Levitsky

