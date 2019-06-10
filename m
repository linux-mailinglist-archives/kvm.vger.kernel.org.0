Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10EB43B8B1
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2019 17:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403981AbfFJPzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 11:55:00 -0400
Received: from ahs5.r4l.com ([158.69.52.156]:49005 "EHLO ahs5.r4l.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390778AbfFJPzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 11:55:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=extremeground.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hoYK19Vb/MIi2yfcMQlFWxqhkOCxSlzpAYdmJKeyjyY=; b=LVeNUpF5gW/rE4GfdeLAd66EgN
        OZqWhfjLnQqPxsJEGr4WP4qDiLC7GZhuJlEu8oAcyuFACjliqcmVMx6PklM3dGJoglC4H3fD7NN0V
        qyJSFMd3Qy2dhbPU5jt0B1ibZBhPGmQz2e/vA4AeZIr2vpTPGK8DFKONCJy+mlU6Zp7LQe7zViEac
        kTrDJOEa0t5APCHj6r20Up52GTihUqxuqmSfDi1K7hNPbx0H6OTXi7dqN2yG0IoNxB3imWbLrypmV
        682yth/u29XJlqS/EsTl7B/UPOieSOZ0Cu4kO3vDs+7wSU5Jv0yYX8vK/IPpRbo7vjmHzhRD7B/oP
        PX+YWrlg==;
Received: from cpeac202ed5e073-cmac202ed5e070.cpe.net.cable.rogers.com ([99.237.87.227]:44326 helo=[192.168.1.20])
        by ahs5.r4l.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <gary@extremeground.com>)
        id 1haMdL-0007fx-SQ; Mon, 10 Jun 2019 11:54:55 -0400
Subject: Re: kvm / virsh snapshot management
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Kevin Wolf <kwolf@redhat.com>, John Snow <jsnow@redhat.com>
References: <abb7990e-0331-67a4-af92-05276366478c@extremeground.com>
 <20190610121941.GI14257@stefanha-x1.localdomain>
From:   Gary Dale <gary@extremeground.com>
Message-ID: <dc7a70ea-c94f-e975-df44-b0199da698e2@extremeground.com>
Date:   Mon, 10 Jun 2019 11:54:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190610121941.GI14257@stefanha-x1.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
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

On 2019-06-10 8:19 a.m., Stefan Hajnoczi wrote:
> On Sat, Jun 01, 2019 at 08:12:01PM -0400, Gary Dale wrote:
>> A while back I converted a raw disk image to qcow2 to be able to use
>> snapshots. However I realize that I may not really understand exactly how
>> snapshots work. In this particular case, I'm only talking about internal
>> snapshots currently as there seems to be some differences of opinion as to
>> whether internal or external are safer/more reliable. I'm also only talking
>> about shutdown state snapshots, so it should just be the disk that is
>> snapshotted.
>>
>> As I understand it, the first snapshot freezes the base image and subsequent
>> changes in the virtual machine's disk are stored elsewhere in the qcow2 file
>> (remember, only internal snapshots). If I take a second snapshot, that
>> freezes the first one, and subsequent changes are now in third location.
>> Each new snapshot is incremental to the one that preceded it rather than
>> differential to the base image. Each new snapshot is a child of the previous
>> one.
> Internal snapshots are not incremental or differential at the qcow2
> level, they are simply a separate L1/L2 table pointing to data clusters.
> In other words, they are an independent set of metadata showing the full
> state of the image at the point of the snapshot.  qcow2 does not track
> relationships between snapshots and parents/children.
Which sounds to me like they are incremental. Each snapshot starts a new 
L1/L2 table so that the state of the previous one is preserved.
>
>> One explanation I've seen of the process is if I delete a snapshot, the
>> changes it contains are merged with its immediate child.
> Nope.  Deleting a snapshot decrements the reference count on all its
> data clusters.  If a data cluster's reference count reaches zero it will
> be freed.  That's all, there is no additional data movement or
> reorganization aside from this.
Perhaps not physically but logically it would appear that the data 
clusters were merged.
>
>> So if I deleted the
>> first snapshot, the base image stays the same but any data that has changed
>> since the base image is now in the second snapshot's location. The merge
>> with children explanation also implies that the base image is never touched
>> even if the first snapshot is deleted.
>>
>> But if I delete a snapshot that has no children, is that essentially the
>> same as reverting to the point that snapshot was created and all subsequent
>> disk changes are lost? Or does it merge down to the parent snapshot? If I
>> delete all snapshots, would that revert to the base image?
> No.  qcow2 has the concept of the current disk state of the running VM -
> what you get when you boot the guest - and the snapshots - they are
> read-only.
>
> When you delete snapshots the current disk state (running VM) is
> unaffected.
>
> When you apply a snapshot this throws away the current disk state and
> uses the snapshot as the new current disk state.  The read-only snapshot
> itself is not modified in any way and you can apply the same snapshot
> again as many times as you wish later.
So in essence the current state is a pointer to the latest data cluster, 
which is the only data cluster that can be modified.
>
>> I've seen it explained that a snapshot is very much like a timestamp so
>> deleting a timestamp removes the dividing line between writes that occurred
>> before and after that time, so that data is really only removed if I revert
>> to some time stamp - all writes after that point are discarded. In this
>> explanation, deleting the oldest timestamp is essentially updating the base
>> image. Deleting all snapshots would leave me with the base image fully
>> updated.
>>
>> Frankly, the second explanation sounds more reasonable to me, without having
>> to figure out how copy-on-write works,  But I'm dealing with important data
>> here and I don't want to mess it up by mishandling the snapshots.
>>
>> Can some provide a little clarity on this? Thanks!
> If you want an analogy then git(1) is a pretty good one.  qcow2 internal
> snapshots are like git tags.  Unlike branches, tags are immutable.  In
> qcow2 you only have a master branch (the current disk state) from which
> you can create a new tag or you can use git-checkout(1) to apply a
> snapshot (discarding whatever your current disk state is).
>
> Stefan

That's just making things less clear - I've never tried to understand 
git either. Thanks for the attempt though.

If I've gotten things correct, once the base image is established, there 
is a current disk state that points to a table containing all the writes 
since the base image. Creating a snapshot essentially takes that pointer 
and gives it the snapshot name, while creating a new current disk state 
pointer and data table where subsequent writes are recorded.

Deleting snapshots removes your ability to refer to a data table by 
name, but the table itself still exists anonymously as part of a chain 
of data tables between the base image and the current state.

This leaves a problem. The chain will very quickly get quite long which 
will impact performance. To combat this, you can use blockcommit to 
merge a child with its parent or blockpull to merge a parent with its child.

In my situation, I want to keep a week of daily snapshots in case 
something goes horribly wrong with the VM (I recently had a database 
file become corrupt, and reverting to the previous working day's image 
would have been a quick and easy solution, faster than recovering all 
the data tables from the prefious day). I've been shutting down the VM, 
deleting the oldest snapshot and creating a new one before restarting 
the VM.

While your explanation confirms that this is safe, it also implies that 
I need to manage the data table chains. My first instinct is to use 
blockcommit before deleting the oldest snapshot, such as:

     virsh blockcommit <vm name> <qcow2 file path> --top <oldest 
snapshot> --delete --wait
     virsh snapshot-delete  --domain <vm name> --snapshotname <oldest 
snapshot>

so that the base image contains the state as of one week earlier and the 
snapshot chains are limited to 7 links.

1) does this sound reasonable?

2) I note that the syntax in virsh man page is different from the syntax 
at 
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/sect-backing-chain 
(RedHat uses --top and --base while the man page just has optional base 
and top names). I believe the RedHat guide is correct because the man 
page doesn't allow distinguishing between the base and the top for a commit.

However the need for specifying the path isn't obvious to me. Isn't the 
path contained in the VM definition?

Since blockcommit would make it impossible for me to revert to an 
earlier state (because I'm committing the oldest snapshot, if it screws 
up, I can't undo within virsh), I need to make sure this command is correct.

