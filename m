Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC6732172
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2019 03:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfFBBVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jun 2019 21:21:37 -0400
Received: from ahs5.r4l.com ([158.69.52.156]:54481 "EHLO ahs5.r4l.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfFBBVh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jun 2019 21:21:37 -0400
X-Greylist: delayed 4174 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Jun 2019 21:21:36 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=extremeground.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vEKtx9pZYhUtYAIpewcbFvcmezrV0ydZh2tCYu1vvb0=; b=0vAevecg9a3IuQ0a4n7XsUAT8O
        e7MUdTiEG7I5xb+9W2r/784TAten8xizBHanZV1XSVIMlE60sYCokQwiDCKqefdOkALnjmYW7+lJp
        FLhV9LNNyPfyQSGNyNuGWLD1jQjD6rSCBbiCintUe/QSGX1fIzl4nelZgrH6yPi2janT10Aua5ZiN
        sI9N84otxhqC+8j3HbMGr+uvATpdT+4oKz5ZGplJdJD4PZ7Ff56RA77H9YWZ0fnS0G/R/8DDCBCI9
        bn7EwoG3ASnCBlQ+SgIuO/KOigJYCn0WG7sC8UTyrptnLXeRW+47T/ISEdQEbqWCOIU+gc05uhQug
        eXozTrZw==;
Received: from cpeac202ed5e073-cmac202ed5e070.cpe.net.cable.rogers.com ([99.237.87.227]:42306 helo=[192.168.1.20])
        by ahs5.r4l.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <gary@extremeground.com>)
        id 1hXE6T-0000lr-TQ
        for kvm@vger.kernel.org; Sat, 01 Jun 2019 20:12:01 -0400
To:     kvm@vger.kernel.org
From:   Gary Dale <gary@extremeground.com>
Subject: kvm / virsh snapshot management
Message-ID: <abb7990e-0331-67a4-af92-05276366478c@extremeground.com>
Date:   Sat, 1 Jun 2019 20:12:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-CA
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ahs5.r4l.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - extremeground.com
X-Get-Message-Sender-Via: ahs5.r4l.com: authenticated_id: gary@extremeground.com
X-Authenticated-Sender: ahs5.r4l.com: gary@extremeground.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A while back I converted a raw disk image to qcow2 to be able to use 
snapshots. However I realize that I may not really understand exactly 
how snapshots work. In this particular case, I'm only talking about 
internal snapshots currently as there seems to be some differences of 
opinion as to whether internal or external are safer/more reliable. I'm 
also only talking about shutdown state snapshots, so it should just be 
the disk that is snapshotted.

As I understand it, the first snapshot freezes the base image and 
subsequent changes in the virtual machine's disk are stored elsewhere in 
the qcow2 file (remember, only internal snapshots). If I take a second 
snapshot, that freezes the first one, and subsequent changes are now in 
third location. Each new snapshot is incremental to the one that 
preceded it rather than differential to the base image. Each new 
snapshot is a child of the previous one.

One explanation I've seen of the process is if I delete a snapshot, the 
changes it contains are merged with its immediate child. So if I deleted 
the first snapshot, the base image stays the same but any data that has 
changed since the base image is now in the second snapshot's location. 
The merge with children explanation also implies that the base image is 
never touched even if the first snapshot is deleted.

But if I delete a snapshot that has no children, is that essentially the 
same as reverting to the point that snapshot was created and all 
subsequent disk changes are lost? Or does it merge down to the parent 
snapshot? If I delete all snapshots, would that revert to the base image?

I've seen it explained that a snapshot is very much like a timestamp so 
deleting a timestamp removes the dividing line between writes that 
occurred before and after that time, so that data is really only removed 
if I revert to some time stamp - all writes after that point are 
discarded. In this explanation, deleting the oldest timestamp is 
essentially updating the base image. Deleting all snapshots would leave 
me with the base image fully updated.

Frankly, the second explanation sounds more reasonable to me, without 
having to figure out how copy-on-write works,  But I'm dealing with 
important data here and I don't want to mess it up by mishandling the 
snapshots.

Can some provide a little clarity on this? Thanks!


